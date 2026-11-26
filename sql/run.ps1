param([string]$Isql = 'isql.exe')

$work = Join-Path ([IO.Path]::GetTempPath()) ('isfce-sql-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work -ErrorAction Stop | Out-Null
$database = Join-Path $work 'workshop.fdb'
$escapedPath = $database.Replace('\', '/').Replace("'", "''")
try {
    $inputLines = @("CREATE DATABASE '$escapedPath' USER 'SYSDBA' PASSWORD 'local-demo';")
    $inputLines += Get-Content -LiteralPath (Join-Path $PSScriptRoot 'practice.sql')
    $results = $inputLines | & $Isql -q -b 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) { throw ($results -join [Environment]::NewLine) }
    if (($results -join ' ') -notmatch '18\.50' -or ($results -join ' ') -notmatch 'DEMO-01') {
        throw 'Unexpected invoice total or parking result.'
    }

    $rejected = @('UPDATE order_line SET quantity = 5 WHERE order_id = 2;', 'COMMIT;') |
        & $Isql -q -b -user SYSDBA -password local-demo $database 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -eq 0 -or ($rejected -join ' ') -notmatch 'Order is closed') {
        throw ('Expected the closed-order trigger to reject the update: ' + ($rejected -join ' '))
    }
    $results
    'Verified: invoice total, parking history and closed order trigger.'
} finally {
    if (Test-Path -LiteralPath $database) { Remove-Item -LiteralPath $database }
    [IO.Directory]::Delete($work)
}
