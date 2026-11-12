# No external programs, interpolation, evaluation, package installation or writes.
# Deliberately restricted TOML: named tables, single-line literal strings and bools.
function Read-BuildConfiguration {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)][string]$Path)
    $fullPath = [IO.Path]::GetFullPath($Path)
    $bytes = [IO.File]::ReadAllBytes($fullPath)
    if ($bytes.Length -gt 65536) { throw 'Configuration must be at most 64 KiB.' }
    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $text = $utf8.GetString($bytes)
    if ($text.Length -gt 0 -and $text[0] -eq [char]0xFEFF) { $text = $text.Substring(1) }
    if ($text -match '[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]' -or $text -match '\r(?!\n)') { throw 'Unsupported control character or bare CR in configuration.' }
    $schema = [ordered]@{
        'schema'='string'
        'source.repo'='string'; 'source.commit'='string'; 'source.remote_url'='string'
        'output.run_root'='string'
        'idf.path'='string'; 'idf.python_path'='string'; 'idf.tools_path_mode'='string'; 'idf.tools_path_value'='string'
        'tools.git.mode'='string'; 'tools.git.value'='string'
        'tools.node.mode'='string'; 'tools.node.value'='string'
        'tools.cmake.mode'='string'; 'tools.cmake.value'='string'
        'tools.ninja.mode'='string'; 'tools.ninja.value'='string'
        'tools.compiler.mode'='string'; 'tools.compiler.value'='string'
        'actions.fetch_source'='bool'; 'actions.prepare_dependencies'='bool'
    }
    $allowedTables = @('source','output','idf','tools.git','tools.node','tools.cmake','tools.ninja','tools.compiler','actions')
    $values = [Collections.Generic.Dictionary[string,object]]::new([StringComparer]::Ordinal)
    $tables = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $table = ''
    $lineNumber = 0
    foreach ($line in [regex]::Split($text, "\r?\n")) {
        $lineNumber++
        if ($line -match '^[ \t]*(?:#.*)?$') { continue }
        if ($line -match '^[ \t]*\[([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)*)\][ \t]*(?:#.*)?$') {
            $table = $Matches[1]
            if (!($allowedTables -ccontains $table)) { throw "Unknown table at line $lineNumber." }
            if (!$tables.Add($table)) { throw "Duplicate table at line $lineNumber." }
            continue
        }
        if ($line -notmatch '^[ \t]*([A-Za-z_][A-Za-z0-9_]*)[ \t]*=[ \t]*(.*?)[ \t]*$') { throw "Unsupported TOML syntax at line $lineNumber." }
        $key = $Matches[1]
        $raw = $Matches[2]
        $fullKey = if ($table) { $table + '.' + $key } else { $key }
        if (!(@($schema.Keys) -ccontains $fullKey)) { throw "Unknown key at line $lineNumber." }
        if ($values.ContainsKey($fullKey)) { throw "Duplicate key at line $lineNumber." }
        # Double quotes, backslash escapes, arrays, numbers, multiline strings,
        # inline tables and expressions are intentionally unsupported. A # inside
        # a literal string is data; outside it a comment may follow.
        if ($raw -match "^'([^'\x00-\x08\x0A-\x1F\x7F]*)'[ \t]*(?:#.*)?$") {
            $value = $Matches[1]
            if ($schema[$fullKey] -ne 'string' -or [string]::IsNullOrWhiteSpace($value)) { throw "Wrong type or empty value at line $lineNumber." }
        } elseif ($raw -cmatch '^(true|false)[ \t]*(?:#.*)?$') {
            if ($schema[$fullKey] -ne 'bool') { throw "Wrong type at line $lineNumber." }
            $value = ($Matches[1] -ceq 'true')
        } else { throw "Unsupported value syntax at line $lineNumber. Use single-quoted literal strings or true/false." }
        $values.Add($fullKey,$value)
    }
    foreach ($key in $schema.Keys) { if (!$values.ContainsKey($key)) { throw "Missing configuration key: $key" } }
    if ($values['schema'] -cne 'cardputer-build-v3') { throw 'Unsupported configuration schema.' }
    if ($values['source.commit'] -notmatch '^[0-9a-fA-F]{40}$') { throw 'source.commit must be a full 40-character SHA.' }
    if ($values['idf.tools_path_mode'] -cnotin @('path','environment')) { throw 'idf.tools_path_mode must be path or environment.' }
    if ($values['idf.tools_path_mode'] -ceq 'environment' -and $values['idf.tools_path_value'] -cne 'IDF_TOOLS_PATH') { throw 'The only supported explicit environment selector is IDF_TOOLS_PATH.' }
    foreach ($tool in @('git','node','cmake','ninja','compiler')) {
        if ($values["tools.$tool.mode"] -cnotin @('path','command')) { throw "tools.$tool.mode must be path or command." }
        if ($values["tools.$tool.mode"] -ceq 'command' -and $values["tools.$tool.value"] -notmatch '^[A-Za-z0-9_.+-]+$') { throw "tools.$tool.value must be one literal command name, not arguments or a path." }
    }
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $hash = ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-','').ToLowerInvariant() } finally { $sha.Dispose() }
    return [pscustomobject]@{Path=$fullPath; Sha256=$hash; Values=$values}
}

function Get-ApplicationPaths {
    [CmdletBinding()]
    param([string]$Name)
    # Preserve active command precedence. Sorting candidates changes the choice;
    # repeated PATH entries (including case variants) do not create a new tool.
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($command in @(Get-Command -Name $Name -All -CommandType Application -ErrorAction SilentlyContinue)) {
        $path = [IO.Path]::GetFullPath($command.Source)
        if ($seen.Add($path)) { Write-Output $path }
    }
}

function Resolve-ConfiguredTool {
    [CmdletBinding()]
    param($Configuration, [string]$Tool)
    $mode = $Configuration.Values["tools.$Tool.mode"]
    $value = $Configuration.Values["tools.$Tool.value"]
    if ($mode -ceq 'path') { return $value }
    # Command mode explicitly requests the first active Application. Never try
    # a later installation if the selected executable is missing/old/failing.
    $resolved = @(Get-ApplicationPaths -Name $value)
    if ($resolved.Count -eq 0) { throw "Configured command selector for $Tool was not found: $value. No fallback or PATH changes will be made." }
    return $resolved[0]
}

function Assert-FirstApplicationPath {
    [CmdletBinding()]
    param([string]$Name, [string]$Supplied, [string[]]$Candidates)
    if (@($Candidates).Count -eq 0 -or ![StringComparer]::OrdinalIgnoreCase.Equals($Candidates[0], [IO.Path]::GetFullPath($Supplied))) {
        throw "First active PATH executable for $Name differs from its configured path: $Supplied. Ordered candidates: $($Candidates -join '; '). Child tools invoke this command by name; no PATH changes will be made."
    }
}

function Assert-CMakeToolPaths {
    [CmdletBinding()]
    param([string]$CacheText, [Collections.IDictionary]$Expected)
    $actual = [Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
    foreach ($line in [regex]::Split($CacheText, "\r?\n")) {
        if ($line -match '^([^#/:=]+):([^:=]+)=(.*)$' -and (@($Expected.Keys) -ccontains $Matches[1])) {
            $key = $Matches[1]
            $value = $Matches[3]
            if ($actual.ContainsKey($key)) { throw "Duplicate CMake tool cache entry: $key" }
            if ($value -notmatch '^[A-Za-z]:[\\/]' -or $value -match '[;\r\n]') { throw "CMake tool cache entry must be one absolute local path: $key" }
            $path = [IO.Path]::GetFullPath($value)
            if (![StringComparer]::OrdinalIgnoreCase.Equals($path, [IO.Path]::GetFullPath($Expected[$key]))) {
                throw "Configured CMake tool differs for $key. Expected: $($Expected[$key]); actual: $value"
            }
            $actual[$key] = $path
        }
    }
    foreach ($key in $Expected.Keys) { if (!$actual.ContainsKey($key)) { throw "Missing CMake tool cache entry: $key" } }
    return $actual
}
