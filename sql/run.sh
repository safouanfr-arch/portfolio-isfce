#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
isql="${ISQL:-isql-fb}"
scratch=$(mktemp -d)
trap 'rm -f -- "$scratch/workshop.fdb" "$scratch/results" "$scratch/rejected"; rmdir -- "$scratch"' EXIT

{
    printf "CREATE DATABASE '%s' USER 'SYSDBA' PASSWORD 'local-demo';\n" "$scratch/workshop.fdb"
    cat practice.sql
} | "$isql" -q -b > "$scratch/results"

grep -Eq '18\.50' "$scratch/results"
grep -q 'DEMO-01' "$scratch/results"
grep -q 'OPEN' "$scratch/results"
if "$isql" -q -b -user SYSDBA -password local-demo "$scratch/workshop.fdb" > "$scratch/rejected" 2>&1 <<'SQL'
UPDATE order_line SET quantity = 5 WHERE order_id = 2;
COMMIT;
SQL
then
    echo "Expected the closed order update to fail" >&2
    exit 1
fi
grep -q 'Order is closed' "$scratch/rejected"
cat "$scratch/results"
printf '\nVerified: invoice total, parking history and closed order trigger.\n'
