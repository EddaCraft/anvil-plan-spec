#
# APS CLI Design Document Validation Rules
# All rules are WARNINGS only — free-form designs are accepted.
#

# Dependencies (Output, Common) must be imported by the entry point.

# W014: Missing ## Problem section
function Test-W014Problem {
    param([string]$File)
    if (-not (Test-ApsSection -FilePath $File -SectionHeader "## Problem")) {
        Add-ApsResult -Path $File -Type "warning" -Code "W014" -Message "Missing ## Problem section"
    }
}

# W015: Missing ## Design section
function Test-W015Design {
    param([string]$File)
    if (-not (Test-ApsSection -FilePath $File -SectionHeader "## Design")) {
        Add-ApsResult -Path $File -Type "warning" -Code "W015" -Message "Missing ## Design section"
    }
}

# W016: Missing metadata table with Status field
function Test-W016DesignMetadata {
    param([string]$File)
    $lines = Get-Content -LiteralPath $File -ErrorAction SilentlyContinue
    if (-not $lines) { return }
    $limit = [Math]::Min(20, $lines.Count)
    $hasHeader = $false
    $hasStatus = $false
    for ($i = 0; $i -lt $limit; $i++) {
        if ($lines[$i] -match '^\| *Field *\|') { $hasHeader = $true }
        if ($lines[$i] -match '^\| *Status *\|') { $hasStatus = $true }
    }
    if (-not ($hasHeader -and $hasStatus)) {
        Add-ApsResult -Path $File -Type "warning" -Code "W016" -Message "Missing metadata table with Status field"
    }
}

# Run all design rules (warnings only)
function Invoke-ApsDesignLint {
    param([string]$File)

    Test-W014Problem -File $File
    Test-W015Design -File $File
    Test-W016DesignMetadata -File $File

    return $true
}

Export-ModuleMember -Function 'Invoke-ApsDesignLint'
