# Sort-URLs.ps1
# Sorts URLs from urls.txt by domain hierarchy (TLD first, then ascending domain levels)
# Output: urls_sorted.txt in the same directory

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$inputFile  = Join-Path $scriptDir "urls.txt"
$outputFile = Join-Path $scriptDir "urls_sorted.txt"

if (-not (Test-Path $inputFile)) {
    Write-Error "Input file not found: $inputFile"
    exit 1
}

$urls = Get-Content $inputFile | Where-Object { $_.Trim() -ne "" } | Select-Object -Unique

$sorted = $urls | Sort-Object -Property {
    # Split the URL into parts and reverse them so we sort TLD → SLD → subdomain
    $parts = $_.Trim().ToLower() -split '\.'
    [array]::Reverse($parts)
    # Join reversed parts to create a sortable key, e.g. "com.google.myactivity"
    $parts -join '.'
}

$sorted | Set-Content $outputFile -Encoding UTF8

Write-Host "Done! Sorted $($urls.Count) URLs."
Write-Host "Output written to: $outputFile"