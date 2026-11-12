#requires -Version 5.1
# Synthetic command results only: no tool execution, PATH changes or file writes.
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'These path fixtures require Windows PowerShell 5.1+ or PowerShell 7 on Windows.' }
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'Read-BuildConfig.ps1')
$script:FixtureCandidates = @()
$script:LookupCount = 0
function Get-Command {
    [CmdletBinding()]
    param([string]$Name, [switch]$All, [string]$CommandType)
    if (!$All -or $CommandType -ne 'Application') { throw 'Unexpected command lookup.' }
    $script:LookupCount++
    foreach ($path in $script:FixtureCandidates) { [pscustomobject]@{Source=$path} }
}
function Expect-Failure([scriptblock]$Action) {
    $failed = $false
    try { & $Action | Out-Null } catch { $failed = $true }
    if (!$failed) { throw 'Expected a refusal.' }
}
function Check([bool]$Condition) { if (!$Condition) { throw 'Fixture assertion failed.' } }
$count = 0
function Case([string]$Name, [scriptblock]$Action) {
    & $Action
    $script:count++
    Write-Host "PASS $Name"
}
$Node = 'C:\Program Files\nodejs\node.exe'
$Volta = 'C:\Program Files\Volta\node.exe'
Case 'explicit_node_with_two_candidates' {
    $script:FixtureCandidates = @($Volta,$Node)
    $script:LookupCount = 0
    $config = [pscustomobject]@{Values=@{'tools.node.mode'='path'; 'tools.node.value'=$Node}}
    Check ((Resolve-ConfiguredTool $config 'node') -ceq $Node)
    Check ($script:LookupCount -eq 0)
}
Case 'explicit_node_absent_from_path' {
    $script:FixtureCandidates = @()
    $config = [pscustomobject]@{Values=@{'tools.node.mode'='path'; 'tools.node.value'=$Node}}
    Check ((Resolve-ConfiguredTool $config 'node') -ceq $Node)
}
Case 'command_preserves_active_order' {
    $script:FixtureCandidates = @('C:\z-active\node.exe','C:\a-other\node.exe')
    $config = [pscustomobject]@{Values=@{'tools.node.mode'='command'; 'tools.node.value'='node'}}
    Check ((Resolve-ConfiguredTool $config 'node') -ceq 'C:\z-active\node.exe')
}
Case 'command_missing_does_not_fallback' {
    $script:FixtureCandidates = @()
    $config = [pscustomobject]@{Values=@{'tools.node.mode'='command'; 'tools.node.value'='node'}}
    Expect-Failure { Resolve-ConfiguredTool $config 'node' }
}
Case 'duplicate_paths_preserve_order' {
    $script:FixtureCandidates = @($Volta,$Volta.ToLowerInvariant(),$Volta.Replace('\','/'),$Node,$Node)
    $paths = @(Get-ApplicationPaths 'node')
    Check ($paths.Count -eq 2 -and $paths[0] -ceq $Volta -and $paths[1] -ceq $Node)
}
foreach ($tool in @('git','cmake','ninja','xtensa-esp32s3-elf-gcc')) {
    Case ($tool + '_first_with_later_candidate') {
        Assert-FirstApplicationPath $tool "C:\active\$tool.exe" @("C:\active\$tool.exe","C:\other\$tool.exe")
    }
    Case ($tool + '_wrong_first_refused') {
        Expect-Failure { Assert-FirstApplicationPath $tool "C:\other\$tool.exe" @("C:\active\$tool.exe","C:\other\$tool.exe") }
    }
}
Case 'bare_tool_missing_refused' {
    Expect-Failure { Assert-FirstApplicationPath 'git' 'C:\active\git.exe' @() }
}
$Expected = [ordered]@{POCKET_NODE=$Node; CMAKE_COMMAND='C:\idf\cmake.exe'; CMAKE_MAKE_PROGRAM='C:\idf\ninja.exe'; PYTHON='C:\idf\python.exe'}
$Cache = ($Expected.Keys | ForEach-Object { $_ + ':FILEPATH=' + $Expected[$_].Replace('\','/') }) -join "`n"
Case 'cache_accepts_selected_paths' {
    $actual = Assert-CMakeToolPaths $Cache $Expected
    Check ($actual.Count -eq 4 -and $actual['POCKET_NODE'] -ceq $Node)
}
foreach ($key in $Expected.Keys) {
    Case ($key + '_mismatch_refused') {
        $changed = $Cache.Replace($Expected[$key].Replace('\','/'),'C:/other/tool.exe')
        Expect-Failure { Assert-CMakeToolPaths $changed $Expected }
    }
}
Case 'cache_missing_refused' { Expect-Failure { Assert-CMakeToolPaths ($Cache.Replace('POCKET_NODE:','OTHER:')) $Expected } }
Case 'cache_duplicate_refused' { Expect-Failure { Assert-CMakeToolPaths ($Cache + "`nPOCKET_NODE:FILEPATH=$Node") $Expected } }
Case 'cache_relative_refused' { Expect-Failure { Assert-CMakeToolPaths ($Cache.Replace($Node.Replace('\','/'),'node.exe')) $Expected } }
Case 'cache_lowercase_name_refused' { Expect-Failure { Assert-CMakeToolPaths ($Cache.Replace('POCKET_NODE:','pocket_node:')) $Expected } }
Case 'cache_list_refused' { Expect-Failure { Assert-CMakeToolPaths ($Cache.Replace($Node.Replace('\','/'),($Node + ';other'))) $Expected } }
Write-Host "$count synthetic PowerShell tool-selection/cache cases passed. No real tool resolution or IDF build was tested."
