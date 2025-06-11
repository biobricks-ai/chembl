# ChEMBL — Curated Bioactivity Database

> **Brick ID:** `biobricks-ai/chembl`
>
> **Release pinned:** **ChEMBL 34** (September 2024)
>
> **Primary asset:** `chembl_34.sqlite` (≈ 16 GB uncompressed; mirrors EMBL‑EBI dump byte‑for‑byte)
>
> **Licence:** Creative Commons 0 (CC‑0)

---

## What is ChEMBL?

ChEMBL is EMBL‑EBI’s flagship, manually curated database of small‑molecule bioactivity measurements extracted from medicinal‑chemistry papers and high‑throughput screens.  It is widely used for QSAR, drug‑target interaction, and AI‑assisted molecule design.

This brick ships the **official SQLite dump** for ChEMBL 34.  No rows, columns, or indices have been altered—so anything you can do with the original file works here too.  If you prefer columnar analytics (Parquet, Arrow, DuckDB, Spark), see the “On‑the‑fly Parquet” section below.

---

## File layout

```
brick/
└─ chembl_34.sqlite    # full relational schema with indices
```

Key tables and row counts (ChEMBL 34):

| Table                 | Rows (×10  3) | Notes                                         |
| --------------------- | ------------- | --------------------------------------------- |
| `molecule_dictionary` | **2 210**     | Unique compounds (one per `molregno`)         |
| `activities`          | **20 691**    | Bioactivity records (IC50, Ki, % inhibition…) |
| `assays`              | **1 500**     | Assay metadata                                |
| `target_dictionary`   | **15.9**      | Protein / complex targets                     |
| `docs`                | **78.3**      | Source articles & patents                     |

*Row counts are in thousands for readability.*

---

## Quick start

Need a fast peek at what’s inside the database?  Here’s the most minimal snippet—**just enough to list every table name**:

```python
import biobricks, sqlite3, pandas as pd
path = biobricks.assets("chembl").chembl_34_sqlite

conn = sqlite3.connect(path)
# list all tables ordered alphabetically
pd.read_sql("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;", conn)
```

That query returns a tidy one‑column dataframe with \~70 table names. From there you can `SELECT * FROM <table> LIMIT 5` to inspect any table’s schema and sample rows.

---

## Provenance & update pipeline

| Stage        | Script                | Action                                                                          |
| ------------ | --------------------- | ------------------------------------------------------------------------------- |
| **Download** | `stages/1_fetch.sh`   | Fetches `chembl_34.db.gz` from the EMBL‑EBI FTP mirror and verifies SHA‑256.    |
| **Unpack**   | `stages/2_unpack.sh`  | Decompresses the file to `chembl_34.sqlite`.                                    |
| **Manifest** | `stages/3_manifest.R` | Writes row counts + column hashes to `brick/manifest.yaml` for reproducibility. |

The brick is regenerated automatically when ChEMBL publishes a new version (\~annual). Every build is pinned to a Git commit so you can reproducibly `brick_pull chembl@<hash>`.

---

## Performance and best‑practice tips

1. **Use indices** – heavy filters on `molregno`, `tid`, `assay_id`, or `standard_type` are index‑optimised.
2. **Confidence score ≥ 5** – for reliable SAR, join through `assays.confidence_score`.
3. **Use `pchembl_value`** – ChEMBL already normalises IC50/Ki etc. to `–log10(molar)`.
4. **Predicate pushdown** – after converting to Parquet, Arrow‑aware engines skip irrelevant row groups automatically.

---

## Road‑map

* **Partitioned Parquet snapshot** (`chembl@parquet`) planned for Q4 2025, containing activities, molecules, assays, and targets as separate datasets.
* **Delta Lake mirror** once upstream provides incremental updates.

---

## Citation

```
Mendez, D. et al. (2024) ChEMBL: towards direct deposition of bioassay data. *Nucleic Acids Research* 52:D142‑D150.  
BioBricks.ai – chembl brick, ChEMBL 34, commit <hash>.
```

---

## Licence

ChEMBL data are distributed under **CC‑0**. Feel free to use or redistribute, but please acknowledge EMBL‑EBI / ChEMBL in derivative work.
