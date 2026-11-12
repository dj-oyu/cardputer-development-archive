#requires -Version 5.1
[CmdletBinding()]
param([string]$ScratchDirectory)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (!$PSBoundParameters.ContainsKey('ScratchDirectory') -or [string]::IsNullOrWhiteSpace($ScratchDirectory)) { throw 'Supply a NEW explicit -ScratchDirectory with an existing parent.' }
$ScratchDirectory = [IO.Path]::GetFullPath($ScratchDirectory)
if (Test-Path -LiteralPath $ScratchDirectory) { throw 'ScratchDirectory already exists; it will not be reused or cleaned.' }
if (!(Test-Path -LiteralPath ([IO.Path]::GetDirectoryName($ScratchDirectory)) -PathType Container)) { throw 'ScratchDirectory parent must exist.' }
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'Read-BuildConfig.ps1')
$fixtures = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $PSScriptRoot 'config-fixtures.json') | ConvertFrom-Json
New-Item -ItemType Directory -Path $ScratchDirectory -ErrorAction Stop | Out-Null
$count = 0
foreach ($case in $fixtures.cases) {
    if ($case.name -cnotmatch '^[a-z0-9_]+$') { throw 'Invalid fixture name.' }
    $path = Join-Path $ScratchDirectory ($case.name + '.toml')
    $bytes = [Convert]::FromBase64String($case.utf8_base64)
    $stream = [IO.File]::Open($path,[IO.FileMode]::CreateNew,[IO.FileAccess]::Write,[IO.FileShare]::None)
    try { $stream.Write($bytes,0,$bytes.Length) } finally { $stream.Dispose() }
    $actual = $null
    $failure = $null
    try { $actual = Read-BuildConfiguration -Path $path } catch { $failure = $_.Exception.Message }
    if ($case.valid) {
        if ($failure) { throw "Valid parser case $($case.name) failed: $failure" }
        if ($actual.Values['actions.fetch_source'] -isnot [bool]) { throw 'Boolean was not preserved as Boolean.' }
        if ($case.PSObject.Properties.Name -contains 'expected') {
            foreach ($property in $case.expected.PSObject.Properties) {
                if ($actual.Values[$property.Name] -cne $property.Value) { throw "Literal value changed in $($case.name)." }
            }
        }
    } elseif (!$failure) { throw "Invalid parser case $($case.name) was accepted." }
    $count++
    Write-Host "PASS $($case.name)"
}
Write-Host "$count PowerShell parser cases passed. Fixtures preserved in $ScratchDirectory."
