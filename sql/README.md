# SQL and Firebird Labs

Runnable adaptations of the Intro Base de Donnees and GEB exercises. The script groups the original themes into three small domains with fictional data.

| Lab | Database concepts |
| --- | --- |
| Equipment inventory | Primary and foreign keys, optional ownership, left join |
| Parking | Visit history, open and closed visits, selectable procedure |
| Order billing | Line totals, a selectable invoice procedure, trigger rules on closed orders |

Run with Firebird 3 or newer. The default Firebird `isql` client is called `isql-fb` on Debian and Ubuntu. The runner creates a fresh temporary database and checks the expected output.

```sh
bash sql/run.sh
# On a Firebird distribution that names the tool isql:
ISQL=isql bash sql/run.sh
```

On Windows, use the native Firebird `isql.exe`:

```powershell
.\sql\run.ps1 -Isql 'C:\path\to\isql.exe'
```

The billing example returns `18.50` for order 1. The parking example returns an open and a finished visit for the fictional vehicle `DEMO-01`. The trigger test confirms that an update to a closed order line is rejected.
