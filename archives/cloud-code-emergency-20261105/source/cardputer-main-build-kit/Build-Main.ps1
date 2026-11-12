#requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Config,
    [switch]$Execute
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (Test-Path variable:PSNativeCommandUseErrorActionPreference) { $PSNativeCommandUseErrorActionPreference = $false }
if (!$PSBoundParameters.ContainsKey('Config') -or [string]::IsNullOrWhiteSpace($Config)) { throw 'Missing explicit -Config TOML file. No prompting or configuration defaults are provided.' }
$Config = (Resolve-Path -LiteralPath $Config -ErrorAction Stop).Path
$ConfigParser = Join-Path $PSScriptRoot 'Read-BuildConfig.ps1'
. $ConfigParser
# Parse and validate the complete schema before any external executable runs.
$Configuration = Read-BuildConfiguration -Path $Config
$Settings = $Configuration.Values
$Repo = [string]$Settings['source.repo']
$RunRoot = [string]$Settings['output.run_root']
$Commit = [string]$Settings['source.commit']
$RemoteUrl = [string]$Settings['source.remote_url']
$IdfPath = [string]$Settings['idf.path']
$PythonPath = [string]$Settings['idf.python_path']
if ($Settings['idf.tools_path_mode'] -ceq 'environment') {
    $IdfToolsPath = [Environment]::GetEnvironmentVariable($Settings['idf.tools_path_value'],'Process')
    if ([string]::IsNullOrWhiteSpace($IdfToolsPath)) { throw 'Explicit IDF_TOOLS_PATH selector is unset. Activate the intended environment yourself; no fallback will be used.' }
} else { $IdfToolsPath = [string]$Settings['idf.tools_path_value'] }
$GitPath = Resolve-ConfiguredTool $Configuration 'git'
$NodePath = Resolve-ConfiguredTool $Configuration 'node'
$CMakePath = Resolve-ConfiguredTool $Configuration 'cmake'
$NinjaPath = Resolve-ConfiguredTool $Configuration 'ninja'
$CompilerPath = Resolve-ConfiguredTool $Configuration 'compiler'
$Fetch = [bool]$Settings['actions.fetch_source']
$PrepareDependencies = [bool]$Settings['actions.prepare_dependencies']
$Helper = Join-Path $PSScriptRoot 'collect_evidence.py'
$ReservationHelper = Join-Path $PSScriptRoot 'reserve_run.py'

function Assert-PlainPath([string]$Path) {
    if ($Path -notmatch '^[A-Za-z]:[\\/]' -or $Path.Substring(2).Contains(':') -or $Path -match '[;\r\n]') {
        throw "Use an absolute local drive path, without alternate streams or semicolons: $Path"
    }
    foreach ($part in ($Path.Substring(3) -split '[\\/]')) {
        if ($part -in @('.', '..') -or $part -match '[. ]$') { throw "Non-plain path component: $Path" }
    }
    $cursor = [IO.Path]::GetFullPath($Path)
    while ($cursor) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Junction/symlink path refused: $cursor" }
        }
        $parent = [IO.Path]::GetDirectoryName($cursor)
        if ($parent -eq $cursor) { break }
        $cursor = $parent
    }
    $drive = New-Object IO.DriveInfo ([IO.Path]::GetPathRoot($Path))
    if ($drive.DriveType -notin @([IO.DriveType]::Fixed, [IO.DriveType]::Removable)) { throw 'Use a local fixed/removable drive, not a network drive.' }
}
function Write-Json($Value, [string]$Path) {
    $Value | ConvertTo-Json -Depth 24 | Set-Content -Encoding UTF8 -LiteralPath $Path
}
function Invoke-Logged([string]$Exe, [string[]]$Arguments, [string]$Log) {
    # stderr is preserved as output; every native exit code is checked explicitly.
    $global:LASTEXITCODE = $null
    $old = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        & $Exe @Arguments 2>&1 | Tee-Object -FilePath $Log -ErrorAction Stop | Out-Host
        $code = $global:LASTEXITCODE
    } finally { $ErrorActionPreference = $old }
    if ($null -eq $code -or $code -ne 0) { throw "Command failed ($code): $Exe; see $Log" }
    if (!(Test-Path -LiteralPath $Log -PathType Leaf)) { throw "Command log is missing: $Log" }
}
function Git-Text([string[]]$Arguments) {
    $global:LASTEXITCODE = $null
    $old = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & $GitPath --no-replace-objects --no-lazy-fetch --no-optional-locks @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $old }
    if ($null -eq $code -or $code -ne 0) { throw "Git failed ($code): $($output -join ' ')" }
    return ($output -join "`n").Trim()
}
function Assert-CleanEnvironment {
    $names = @('CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','ASFLAGS','CC','CXX','ASM',
        'SDKCONFIG','SDKCONFIG_DEFAULTS','CMAKE_ARGS','CMAKE_TOOLCHAIN_FILE','CMAKE_PROJECT_INCLUDE',
        'CMAKE_PROJECT_INCLUDE_BEFORE','CMAKE_PROJECT_TOP_LEVEL_INCLUDES','CMAKE_PROGRAM_PATH','CMAKE_PREFIX_PATH','CMAKE_GENERATOR','CMAKE_GENERATOR_TOOLSET',
        'CMAKE_GENERATOR_PLATFORM','CMAKE_C_COMPILER_LAUNCHER','CMAKE_CXX_COMPILER_LAUNCHER',
        'IDF_EXTRA_ACTIONS_PATH','EXTRA_COMPONENT_DIRS','IDF_BUILD_V2','PYTHONHOME','PYTHONPATH','NODE_OPTIONS','GIT_NO_LAZY_FETCH','GIT_NO_REPLACE_OBJECTS')
    foreach ($name in $names) {
        if ([Environment]::GetEnvironmentVariable($name)) { throw "Inherited $name is set. Start a clean PowerShell session without build overrides." }
    }
    foreach ($item in Get-ChildItem Env:) {
        if (($item.Name -match '^(IDF_COMPONENT_|COMPONENT_MANAGER_|DEFAULT_COMPONENT_SERVICE_URL$)') -and $item.Name -ne 'IDF_COMPONENT_LOCAL_STORAGE_URL') { throw "Unsupported component-manager environment override: $($item.Name). It will not be changed automatically." }
        if ($item.Name -match '^(GIT_(TRACE.*|EXTERNAL_DIFF|DIR|WORK_TREE|INDEX_FILE|COMMON_DIR|OBJECT_DIRECTORY|ALTERNATE_OBJECT_DIRECTORIES|CONFIG.*)|CCACHE_.*|IDF_CCACHE_ENABLE|IDF_COMPONENT_(CACHE.*|STORAGE_URL|REGISTRY_URL)|CMAKE_(C|CXX|ASM|EXE_LINKER|SHARED_LINKER)_FLAGS.*)$') {
            throw "Inherited $($item.Name) is set; use a clean session."
        }
    }
    if ($env:IDF_TARGET -and $env:IDF_TARGET -ne 'esp32s3') { throw 'Inherited IDF_TARGET must be unset or esp32s3.' }
}

function Assert-Executable([string]$Name, [string]$Supplied, [switch]$RequirePathMatch) {
    Assert-PlainPath $Supplied
    if (!(Test-Path -LiteralPath $Supplied -PathType Leaf) -or [IO.Path]::GetExtension($Supplied) -ne '.exe') { throw "Supply an existing .exe for $Name`: $Supplied" }
    $candidates = @(Get-ApplicationPaths -Name $Name)
    if ($RequirePathMatch) { Assert-FirstApplicationPath -Name $Name -Supplied $Supplied -Candidates $candidates }
    return [ordered]@{selectedPath=[IO.Path]::GetFullPath($Supplied); pathCommand=$Name; firstPathCandidate=$(if ($candidates.Count) {$candidates[0]} else {$null}); orderedPathCandidates=$candidates; requiresFirstPathMatch=[bool]$RequirePathMatch}
}
function Repo-Snapshot {
    return [ordered]@{
        head=(Git-Text @('-C',$Repo,'rev-parse','HEAD'))
        branch=(Git-Text @('-C',$Repo,'rev-parse','--abbrev-ref','HEAD'))
        localBranches=(Git-Text @('-C',$Repo,'for-each-ref','--format=%(refname) %(objectname)','refs/heads'))
        status=(Git-Text @('-C',$Repo,'status','--porcelain=v1','--untracked-files=all'))
    }
}

# Read-only preflight. No tool activation, PATH edits, fetches or file writes.
if ($env:OS -ne 'Windows_NT') { throw 'Requires Windows PowerShell 5.1+ or PowerShell 7 on Windows.' }
foreach ($path in @($Config,$ConfigParser,$Repo,$RunRoot,$IdfPath,$IdfToolsPath,$PythonPath,$Helper,$ReservationHelper)) { Assert-PlainPath $path }
$Repo = [IO.Path]::GetFullPath($Repo).TrimEnd('\','/')
$RunRoot = [IO.Path]::GetFullPath($RunRoot).TrimEnd('\','/')
$IdfPath = [IO.Path]::GetFullPath($IdfPath).TrimEnd('\','/')
$IdfToolsPath = [IO.Path]::GetFullPath($IdfToolsPath).TrimEnd('\','/')
$PythonPath = [IO.Path]::GetFullPath($PythonPath)
$Commit = $Commit.ToLowerInvariant()
if ($Repo -eq $RunRoot -or $RunRoot.StartsWith($Repo + '\', [StringComparison]::OrdinalIgnoreCase) -or $Repo.StartsWith($RunRoot + '\', [StringComparison]::OrdinalIgnoreCase)) { throw 'Repo and RunRoot must be separate, non-nested directories.' }
if (!(Test-Path -LiteralPath $Repo -PathType Container)) { throw 'Repo does not exist.' }
if (!(Test-Path -LiteralPath ([IO.Path]::GetDirectoryName($RunRoot)) -PathType Container)) { throw 'RunRoot parent must already exist. No parent directory is created.' }
if (Test-Path -LiteralPath $RunRoot) { throw 'RunRoot already exists (including any sentinel). It will not be opened, reused, removed or overwritten.' }
foreach ($path in @($Helper,$ReservationHelper,$PythonPath)) { if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required file missing: $path" } }
$uri = $null
if (![Uri]::TryCreate($RemoteUrl,[UriKind]::Absolute,[ref]$uri) -or $uri.Scheme -ne 'https' -or $uri.UserInfo -or $uri.Query -or $uri.Fragment) { throw 'RemoteUrl must be an explicit HTTPS repository URL without credentials/query/fragment.' }
Assert-CleanEnvironment
if ($env:IDF_COMPONENT_LOCAL_STORAGE_URL) {
    $storageUri = $null
    if (![Uri]::TryCreate($env:IDF_COMPONENT_LOCAL_STORAGE_URL,[UriKind]::Absolute,[ref]$storageUri) -or $storageUri.UserInfo -or $storageUri.Query -or $storageUri.Fragment) { throw 'IDF_COMPONENT_LOCAL_STORAGE_URL is not a plain absolute URL or contains sensitive URL fields. Its value will not be printed.' }
}
Write-Output 'Read-only preflight temporarily disables Git tracing, replacement objects and lazy fetch in this process. Previous values are restored on return; no persistent settings are changed.'
$ReadOnlyGitEnvironment = [ordered]@{GIT_TRACE2='0'; GIT_TRACE2_EVENT='0'; GIT_TRACE2_PERF='0'; GIT_NO_REPLACE_OBJECTS='1'; GIT_NO_LAZY_FETCH='1'}
$PriorReadOnlyGitEnvironment = @{}
foreach ($name in $ReadOnlyGitEnvironment.Keys) { $PriorReadOnlyGitEnvironment[$name] = [Environment]::GetEnvironmentVariable($name,'Process') }
try {
foreach ($name in $ReadOnlyGitEnvironment.Keys) { [Environment]::SetEnvironmentVariable($name,$ReadOnlyGitEnvironment[$name],'Process') }
if (!$env:IDF_PATH -or [IO.Path]::GetFullPath($env:IDF_PATH).TrimEnd('\','/') -ne $IdfPath) { throw 'IDF_PATH must already equal the explicit IdfPath. This script does not activate environments.' }
if (!$env:IDF_TOOLS_PATH -or [IO.Path]::GetFullPath($env:IDF_TOOLS_PATH).TrimEnd('\','/') -ne $IdfToolsPath -or !(Test-Path -LiteralPath $IdfToolsPath -PathType Container)) { throw 'IDF_TOOLS_PATH must already equal the explicit existing IdfToolsPath. No default tools/cache directory is assumed.' }
$ComponentManagerConfig = Join-Path $IdfToolsPath 'idf_component_manager.yml'
if (Test-Path -LiteralPath $ComponentManagerConfig) { throw 'A custom idf_component_manager.yml exists in IdfToolsPath. Its profiles/mirrors are outside this kit; it will not be read, changed or silently applied.' }
if (!$env:IDF_PYTHON_ENV_PATH -or [IO.Path]::GetFullPath((Join-Path $env:IDF_PYTHON_ENV_PATH 'Scripts/python.exe')) -ne $PythonPath) { throw 'PythonPath must match the already active IDF_PYTHON_ENV_PATH/Scripts/python.exe.' }
foreach ($path in @($PythonPath,$IdfPath,$CompilerPath)) { if ($path -match '(?i)platformio') { throw 'PlatformIO paths are not accepted for this IDF build.' } }
# Only Node is fully bound independently of PATH by this firmware's POCKET_NODE.
# IDF invokes bare cmake AND ninja; dependencies/IDF invoke bare git, and the
# toolchain discovers its compiler. Later installations are harmless, but the
# first active tool must match what this plan checks and records.
$ToolSelection = [ordered]@{
    git=(Assert-Executable 'git' $GitPath -RequirePathMatch)
    node=(Assert-Executable 'node' $NodePath)
    cmake=(Assert-Executable 'cmake' $CMakePath -RequirePathMatch)
    ninja=(Assert-Executable 'ninja' $NinjaPath -RequirePathMatch)
    compiler=(Assert-Executable ([IO.Path]::GetFileNameWithoutExtension($CompilerPath)) $CompilerPath -RequirePathMatch)
}
$Idf = Join-Path $IdfPath 'tools/idf.py'
$PartitionTool = Join-Path $IdfPath 'components/partition_table/gen_esp32part.py'
$VersionFile = Join-Path $IdfPath 'tools/cmake/version.cmake'
foreach ($path in @($Idf,$PartitionTool,$VersionFile)) { if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw "Required explicit IDF installation file missing: $path" } }
$VersionText = Get-Content -Raw -LiteralPath $VersionFile
foreach ($pair in @(@('MAJOR','6'),@('MINOR','0'),@('PATCH','1'))) {
    if ($VersionText -notmatch ('set\(IDF_VERSION_' + $pair[0] + '\s+' + $pair[1] + '\)')) { throw 'This kit requires IDF version.cmake to specify 6.0.1.' }
}
if ([IO.Path]::GetFullPath((Git-Text @('-C',$Repo,'rev-parse','--show-toplevel'))).TrimEnd('\','/') -ne $Repo) { throw 'Repo must be the exact checkout root.' }
$GitConfigNames = (Git-Text @('-C',$Repo,'config','--name-only','--list')) -split "`n"
if ($GitConfigNames | Where-Object { $_ -match '^(filter\.|core\.fsmonitor$|diff\..*(external|textconv)$|url\..*\.(insteadof|pushinsteadof)$)' }) {
    throw 'Git filters, fsmonitor or URL rewrite configuration can cause hidden programs/network behavior. This kit refuses it without changing that configuration.'
}
$OriginUrl = Git-Text @('-C',$Repo,'remote','get-url','origin')
if ($OriginUrl -cne $RemoteUrl) { throw 'Explicit RemoteUrl does not exactly match existing origin URL. No remote is changed or assumed.' }
$GitDirectory = Git-Text @('-C',$Repo,'rev-parse','--absolute-git-dir')
Assert-PlainPath $GitDirectory
$GitCommon = Git-Text @('-C',$Repo,'rev-parse','--git-common-dir')
if (![IO.Path]::IsPathRooted($GitCommon)) { $GitCommon = Join-Path $Repo $GitCommon }
Assert-PlainPath $GitCommon
if (Test-Path -LiteralPath (Join-Path $GitCommon 'info/grafts')) { throw 'Legacy Git grafts are refused; source identity must be unambiguous.' }
$ToolVersions = [ordered]@{}
foreach ($entry in @(@('python',$PythonPath),@('git',$GitPath),@('node',$NodePath),@('cmake',$CMakePath),@('ninja',$NinjaPath),@('compiler',$CompilerPath))) {
    $global:LASTEXITCODE = $null
    $old = $ErrorActionPreference
    try { $ErrorActionPreference = 'Continue'; $version = & $entry[1] --version 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $old }
    if ($null -eq $code -or $code -ne 0) { throw "Explicit tool version check failed: $($entry[0])" }
    $ToolVersions[$entry[0]] = ($version -join "`n").Trim()
}
if ($ToolVersions.node -notmatch '^v(\d+)\.' -or [int]$Matches[1] -lt 16) { throw 'Explicit Node must be version 16 or newer.' }
if ($ToolVersions.python -notmatch '^Python (\d+)\.(\d+)\.' -or [int]$Matches[1] -lt 3 -or ([int]$Matches[1] -eq 3 -and [int]$Matches[2] -lt 9)) { throw 'Explicit Python must be version 3.9 or newer.' }

# --no-lazy-fetch ensures a partial clone cannot fetch behind a read-only plan.
# If this Git lacks that option, preflight fails rather than falling back.
$global:LASTEXITCODE = $null
$PathProbe = & $PythonPath -I -B -S $ReservationHelper --plan-paths --repo $Repo --run-root $RunRoot --commit $Commit
if ($null -eq $LASTEXITCODE -or $LASTEXITCODE -ne 0) { throw 'Read-only canonical path validation failed.' }
$CanonicalPaths = ($PathProbe -join "`n") | ConvertFrom-Json
$LocalCommits = Git-Text @('-C',$Repo,'rev-parse',('--disambiguate=' + $Commit))
$CommitPresent = ($LocalCommits -split "`n") -contains $Commit
if ($CommitPresent -and (Git-Text @('-C',$Repo,'cat-file','-t',$Commit)) -ne 'commit') { throw 'Supplied SHA is not a commit object.' }
$Worktree = Join-Path $RunRoot 'wt-main'
$Build = Join-Path $Worktree 'build_main'
$Logs = Join-Path $RunRoot 'logs'
$EvidenceDir = Join-Path $RunRoot 'evidence'
$Hooks = Join-Path $RunRoot 'empty-hooks'
$ManifestPath = Join-Path $RunRoot 'manifest.json'
$ComponentCache = Join-Path $RunRoot 'cache/idf-components'
$Options = @('-DIDF_TARGET=esp32s3',"-DSDKCONFIG=$Build/sdkconfig", "-DSDKCONFIG_DEFAULTS=$Worktree/sdkconfig.defaults",'-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
    "-DPOCKET_NODE=$NodePath","-DCMAKE_MAKE_PROGRAM=$NinjaPath","-DPYTHON=$PythonPath",'-DCCACHE_ENABLE=OFF')
$ExpectedCMakeTools = [ordered]@{POCKET_NODE=$NodePath; CMAKE_COMMAND=$CMakePath; CMAKE_MAKE_PROGRAM=$NinjaPath; PYTHON=$PythonPath}
$Plan = [ordered]@{
    mode=$(if ($Execute) {'execute'} else {'read-only plan'})
    configuration=[ordered]@{path=$Configuration.Path; sha256=$Configuration.Sha256; idfToolsSelectorMode=$Settings['idf.tools_path_mode']; idfToolsSelectorValue=$Settings['idf.tools_path_value']; gitSelectorMode=$Settings['tools.git.mode']; gitSelectorValue=$Settings['tools.git.value']; nodeSelectorMode=$Settings['tools.node.mode']; nodeSelectorValue=$Settings['tools.node.value']; cmakeSelectorMode=$Settings['tools.cmake.mode']; cmakeSelectorValue=$Settings['tools.cmake.value']; ninjaSelectorMode=$Settings['tools.ninja.mode']; ninjaSelectorValue=$Settings['tools.ninja.value']; compilerSelectorMode=$Settings['tools.compiler.mode']; compilerSelectorValue=$Settings['tools.compiler.value']}
    canonicalPaths=$CanonicalPaths
    sourceCommit=$Commit; repositoryUrl=$RemoteUrl; componentManagerConfigAbsent=$ComponentManagerConfig; configuredOrigin=$OriginUrl; gitDirectory=$GitDirectory; gitCommonDirectory=$GitCommon; remoteVerification='No latest/main lookup; local source is not asserted to be on the remote'
    sourcePresentLocally=$CommitPresent; fetchRequested=[bool]$Fetch; fetchWillRun=(!$CommitPresent -and [bool]$Fetch)
    dependencyPreparationRequested=[bool]$PrepareDependencies
    directories=[ordered]@{repo=$Repo; runRoot=$RunRoot; worktree=$Worktree; build=$Build; logs=$Logs; evidence=$EvidenceDir; disabledHooks=$Hooks; componentCache=$ComponentCache}
    tools=[ordered]@{git=$GitPath; node=$NodePath; cmake=$CMakePath; ninja=$NinjaPath; compiler=$CompilerPath; python=$PythonPath; idf=$Idf; partitionDecoder=$PartitionTool; reservationHelper=$ReservationHelper; evidenceHelper=$Helper}
    toolSelection=$ToolSelection; expectedCMakeTools=$ExpectedCMakeTools
    environment=[ordered]@{IDF_PATH=$env:IDF_PATH; IDF_PYTHON_ENV_PATH=$env:IDF_PYTHON_ENV_PATH; IDF_TARGET=$env:IDF_TARGET; IDF_TOOLS_PATH=$env:IDF_TOOLS_PATH; PATH=$env:PATH; HOME=$env:HOME; USERPROFILE=$env:USERPROFILE; LOCALAPPDATA=$env:LOCALAPPDATA; TEMP=$env:TEMP; TMP=$env:TMP; IDF_COMPONENT_LOCAL_STORAGE_URL=$env:IDF_COMPONENT_LOCAL_STORAGE_URL; IDF_COMPONENT_PROFILE=$env:IDF_COMPONENT_PROFILE}
    target='esp32s3'; requiredIdfVersion='v6.0.1'; cmakeOptions=$Options; toolVersions=$ToolVersions
    preflightProcessEnvironmentChanges=$ReadOnlyGitEnvironment
    processEnvironmentChanges=[ordered]@{GIT_CONFIG_COUNT='1'; GIT_CONFIG_KEY_0='core.hooksPath'; GIT_CONFIG_VALUE_0=$Hooks; IDF_COMPONENT_CACHE_PATH=$ComponentCache; restoration='Restore previous process values in finally; no persistent environment changes'}
    actions=@(
        'Reserve RunRoot using atomic os.mkdir; create a new ownership sentinel exclusively; never reuse/remove it',
        'Set the listed process-local Git hooks configuration for all child git commands; restore it when this script finishes',
        'Create only the listed child directories and write plan/manifest/log/evidence files inside the owned new RunRoot',
        $(if (!$CommitPresent -and $Fetch) {"Fetch ONLY exact $Commit from $RemoteUrl into existing repo objects; no branch refs/FETCH_HEAD/auto-maintenance"} else {'No explicit source fetch'}),
        'Verify exact commit, create detached worktree, record original repo state without changing working files/index/branches',
        $(if ($PrepareDependencies) {'Run selected source tools/prepare_dependencies.py: upstream dependency downloads plus source-local caches; IDF configure/build may access component registries and update dependencies.lock and user/tool caches'} else {'Dependency preparation/network not authorized: execution will be refused'}),
        'Configure/build with only selected source sdkconfig.defaults and a build-local sdkconfig; record configured compiler and IDF identity',
        'Run size reports/flash-budget check; decode partitions; validate and hash generated artifacts; preserve all failure output'
    )
    network=$(if ($PrepareDependencies) {'GitHub dependency repositories and ESP-IDF component/dependency sources selected by this commit; explicit source RemoteUrl fetch only when absent and actions.fetch_source is true'} else {'No dependency network authorized'})
    cacheDisclosure='Component downloads use the explicitly listed process-local IDF_COMPONENT_CACHE_PATH under RunRoot; CMake compiler caching is explicitly OFF. Other tool temporary/metadata writes can occur in the existing IDF_TOOLS_PATH/TEMP/TMP/user locations shown above. No cleanup or existing-resource overwrite is requested; this runner is not a filesystem sandbox.'
    sourceDependencyExample='For reviewed commit 1b4524e3db8524365f58e8c7fb56531c31b55e22: boschsensortec/BMI270_SensorAPI@41129fcfe39c583ee5462d79195741945d51c1fe, xiph/opus@v1.6.1, lieff/minimp3@ea99364f61c14656440e8d77e9c233ccf3124633; other supplied commits must be reviewed separately'
}
$Plan | ConvertTo-Json -Depth 16 | Write-Output
if (!$Execute) { return }
if ((Get-FileHash -Algorithm SHA256 -LiteralPath $Config).Hash.ToLowerInvariant() -ne $Configuration.Sha256) { throw 'Configuration changed during preflight. Review a fresh plan; nothing will be executed.' }
if (!$CommitPresent -and !$Fetch) { throw 'Exact source commit is absent. Set actions.fetch_source = true explicitly in TOML and review a new plan before executing.' }
if (!$PrepareDependencies) { throw 'Fresh worktree needs dependency preparation. Set actions.prepare_dependencies = true explicitly in TOML and review a new plan before executing.' }
# This helper uses atomic mkdir (CreateDirectoryW on Windows), not existing-success
# Directory.CreateDirectory. It refuses races/collisions and writes a sentinel via x.
$global:LASTEXITCODE = $null
& $PythonPath -I -B -S $ReservationHelper --run-root $RunRoot --commit $Commit
if ($null -eq $LASTEXITCODE -or $LASTEXITCODE -ne 0) { throw 'Exclusive RunRoot reservation failed. Nothing is reused or cleaned.' }
foreach ($dir in @($Logs,$EvidenceDir,$Hooks)) { New-Item -ItemType Directory -Path $dir -ErrorAction Stop | Out-Null }
Write-Json $Plan (Join-Path $RunRoot 'plan.json')
$Manifest = [ordered]@{
    schema='pocketjs-toml-build-only-v3'; status='preflight'; startedUtc=[DateTime]::UtcNow.ToString('o')
    repositoryUrl=$RemoteUrl; originalRepo=$Repo; sourceCommit=$Commit; sourceRef=$null; sourceWasLocal=$CommitPresent; fetchPerformed=$false
    worktree=$Worktree; buildDirectory=$Build; target='esp32s3'; requiredIdfVersion='v6.0.1'
    toolSelection=$ToolSelection; expectedCMakeTools=$ExpectedCMakeTools
    configurationPath=$Configuration.Path; configurationSha256=$Configuration.Sha256
    deviceStatus='not run'; failure=$null; evidence=$null; kitHashes=@{}; cmakeOptions=$Options
}
foreach ($path in @($PSCommandPath,$ConfigParser,$Helper,$ReservationHelper)) { $Manifest.kitHashes[[IO.Path]::GetFileName($path)] = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant() }
Write-Json $Manifest $ManifestPath
$SavedGitEnvironment = @{}
foreach ($name in @('GIT_CONFIG_COUNT','GIT_CONFIG_KEY_0','GIT_CONFIG_VALUE_0','IDF_COMPONENT_CACHE_PATH')) { $SavedGitEnvironment[$name] = [Environment]::GetEnvironmentVariable($name,'Process') }
try {
    [Environment]::SetEnvironmentVariable('GIT_CONFIG_COUNT','1','Process')
    [Environment]::SetEnvironmentVariable('GIT_CONFIG_KEY_0','core.hooksPath','Process')
    [Environment]::SetEnvironmentVariable('GIT_CONFIG_VALUE_0',$Hooks,'Process')
    [Environment]::SetEnvironmentVariable('IDF_COMPONENT_CACHE_PATH',$ComponentCache,'Process')
    $Before = Repo-Snapshot
    Write-Json $Before (Join-Path $EvidenceDir 'original-repo-before.json')
    if (!$CommitPresent -and $Fetch) {
        Invoke-Logged $GitPath @('--no-replace-objects','--no-lazy-fetch','-c',"core.hooksPath=$Hooks",'-C',$Repo,'fetch','--no-tags','--no-write-fetch-head','--no-auto-maintenance',$RemoteUrl,$Commit) (Join-Path $Logs 'fetch-commit.log')
        $Manifest.fetchPerformed=$true
    }
    if ((Git-Text @('-C',$Repo,'rev-parse','--verify',"$Commit^{commit}")) -ne $Commit) { throw 'Exact supplied commit is not available.' }
    # Python -B avoids generating Python bytecode caches for our helper/IDF calls.
    Invoke-Logged $PythonPath @('-B',$Idf,'--version') (Join-Path $Logs 'version-idf.log')
    $IdfVersion = (Get-Content -Raw -LiteralPath (Join-Path $Logs 'version-idf.log')).Trim()
    if ($IdfVersion -notmatch '(?m)^ESP-IDF v6\.0\.1\s*$') { throw "Expected exact ESP-IDF v6.0.1, found: $IdfVersion" }
    Invoke-Logged $NodePath @('--version') (Join-Path $Logs 'version-node.log')
    $NodeVersion = (Get-Content -Raw -LiteralPath (Join-Path $Logs 'version-node.log')).Trim()
    if ($NodeVersion -notmatch '^v(\d+)\.' -or [int]$Matches[1] -lt 16) { throw 'Node 16 or newer is required.' }
    foreach ($entry in @(@('python',$PythonPath),@('git',$GitPath),@('cmake',$CMakePath),@('ninja',$NinjaPath),@('compiler',$CompilerPath))) { Invoke-Logged $entry[1] @('--version') (Join-Path $Logs ("version-" + $entry[0] + '.log')) }
    $Manifest.idfPath=$IdfPath; $Manifest.idfPython=$PythonPath; $Manifest.idfVersion=$IdfVersion; $Manifest.nodeVersion=$NodeVersion
    $Manifest.status='preparing'; Write-Json $Manifest $ManifestPath
    Invoke-Logged $GitPath @('--no-replace-objects','--no-lazy-fetch','-c',"core.hooksPath=$Hooks",'-C',$Repo,'worktree','add','--detach',$Worktree,$Commit) (Join-Path $Logs 'worktree-add.log')
    if ((Git-Text @('-C',$Worktree,'rev-parse','HEAD')) -ne $Commit -or (Git-Text @('-C',$Worktree,'rev-parse','--abbrev-ref','HEAD')) -ne 'HEAD') { throw 'Fresh worktree must be detached at the exact supplied commit.' }
    if (Test-Path -LiteralPath (Join-Path $Worktree 'sdkconfig')) { throw 'Fresh source unexpectedly contains root sdkconfig.' }
    Push-Location $Worktree
    try {
        Invoke-Logged $PythonPath @('-B','tools/prepare_dependencies.py') (Join-Path $Logs 'prepare-dependencies.log')
        $Manifest.preparedDependencies = @()
        foreach ($relative in @('.cache/bmi270','.cache/codecs/opus-1.6.1','.cache/codecs/minimp3')) {
            $dependencyPath = Join-Path $Worktree $relative
            $Manifest.preparedDependencies += [ordered]@{path=$dependencyPath; commit=(Git-Text @('-C',$dependencyPath,'rev-parse','HEAD')); origin=(Git-Text @('-C',$dependencyPath,'remote','get-url','origin'))}
        }
        $Manifest.status='configuring'; Write-Json $Manifest $ManifestPath
        Invoke-Logged $PythonPath (@('-B',$Idf,'-B',$Build) + $Options + @('reconfigure')) (Join-Path $Logs 'configure.log')
        Invoke-Logged $PythonPath @('-I','-B','-S',$Helper,'--commit',$Commit,'--git-path',$GitPath,'--worktree',$Worktree,'--build',$Build,'--stage','configure','--output',(Join-Path $EvidenceDir 'configuration.json')) (Join-Path $Logs 'configuration-check.log')
        $Project = Get-Content -Raw -LiteralPath (Join-Path $Build 'project_description.json') | ConvertFrom-Json
        if ([IO.Path]::GetFullPath($Project.c_compiler) -ne [IO.Path]::GetFullPath($CompilerPath)) { throw 'Generated compiler differs from the explicit CompilerPath.' }
        if ([IO.Path]::GetFullPath($Project.idf_path) -ne $IdfPath) { throw 'Generated IDF path differs from the explicit IdfPath.' }
        $Manifest.configuredTools = Assert-CMakeToolPaths -CacheText (Get-Content -Raw -LiteralPath (Join-Path $Build 'CMakeCache.txt')) -Expected $ExpectedCMakeTools
        $Manifest.compiler=$CompilerPath
        $Manifest.status='building'; Write-Json $Manifest $ManifestPath
        Invoke-Logged $PythonPath (@('-B',$Idf,'-B',$Build) + $Options + @('build')) (Join-Path $Logs 'build.log')
        foreach ($action in @('size','size-components','size-files')) { Invoke-Logged $PythonPath (@('-B',$Idf,'-B',$Build) + $Options + @($action)) (Join-Path $Logs "$action.log") }
        Invoke-Logged $PythonPath @('-B','tools/check_flash.py',(Join-Path $Build 'cardputer_pocketjs.bin')) (Join-Path $Logs 'flash-budget.log')
        Invoke-Logged $PythonPath @('-B',$PartitionTool,(Join-Path $Build 'partition_table/partition-table.bin'),(Join-Path $EvidenceDir 'partition-table.csv')) (Join-Path $Logs 'partition-decode.log')
        $Manifest.finalConfiguredTools = Assert-CMakeToolPaths -CacheText (Get-Content -Raw -LiteralPath (Join-Path $Build 'CMakeCache.txt')) -Expected $ExpectedCMakeTools
        Invoke-Logged $PythonPath @('-I','-B','-S',$Helper,'--commit',$Commit,'--git-path',$GitPath,'--worktree',$Worktree,'--build',$Build,'--stage','final','--partitions',(Join-Path $EvidenceDir 'partition-table.csv'),'--output',(Join-Path $EvidenceDir 'build-evidence.json')) (Join-Path $Logs 'evidence-check.log')
    } finally { Pop-Location }
    if ((Git-Text @('-C',$Worktree,'rev-parse','HEAD')) -ne $Commit) { throw 'Worktree HEAD changed during build.' }
    $Status = Git-Text @('-C',$Worktree,'status','--porcelain=v1','--untracked-files=all')
    $Status | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Logs 'worktree-status.log')
    if (Git-Text @('-C',$Worktree,'status','--porcelain=v1','--untracked-files=all','--','.',':(exclude)dependencies.lock')) { throw 'Only dependencies.lock may change; inspect worktree-status.log.' }
    Invoke-Logged $GitPath @('--no-replace-objects','--no-lazy-fetch','-C',$Worktree,'diff','--no-ext-diff','--no-textconv','--','dependencies.lock') (Join-Path $Logs 'dependency-lock-diff.log')
    $After = Repo-Snapshot
    Write-Json $After (Join-Path $EvidenceDir 'original-repo-after.json')
    $Manifest.originalRepoObservationChanged = (($Before | ConvertTo-Json -Compress) -ne ($After | ConvertTo-Json -Compress))
    $Manifest.evidence = Get-Content -Raw -LiteralPath (Join-Path $EvidenceDir 'build-evidence.json') | ConvertFrom-Json
    $Manifest.status='built'; $Manifest.completedUtc=[DateTime]::UtcNow.ToString('o')
} catch {
    $Manifest.status='failed'; $Manifest.failure=$_.Exception.Message
    throw
} finally {
    foreach ($name in $SavedGitEnvironment.Keys) { [Environment]::SetEnvironmentVariable($name,$SavedGitEnvironment[$name],'Process') }
    Write-Json $Manifest $ManifestPath
}
Write-Host "BUILD ONLY complete: $Commit"
Write-Host "App bytes: $($Manifest.evidence.app.bytes) SHA256: $($Manifest.evidence.app.sha256)"
Write-Host "Evidence: $ManifestPath"

} finally {
    foreach ($name in $PriorReadOnlyGitEnvironment.Keys) { [Environment]::SetEnvironmentVariable($name,$PriorReadOnlyGitEnvironment[$name],'Process') }
}
