# 📦 BioBricks.ai / ChEMBL   <!-- built 2025-06-12 -->

_ChEMBL is a manually curated catalogue of bioactive molecules.  
This brick bundles **release 34** in an unmodified SQLite dump so you can
query the full schema locally (Parquet exports will be added later)._

---

## ➤ Quick start

```python
import biobricks as bb, pandas as pd, sqlite3

chembl = bb.assets("chembl")                       # locate brick
conn   = sqlite3.connect(chembl.chembl_34_sqlite)  # open DB

df = pd.read_sql_query(
    """
    SELECT chembl_id, pref_name, molecule_type
    FROM molecule_dictionary
    LIMIT 5;
    """,
    conn,
)
print(df)
