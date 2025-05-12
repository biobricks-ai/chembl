# chembl

## 🔍 Overview
TODO: one‑sentence plain‑language description.

## 📦 Data Source

- **TODO: data source name**  
  URL: [TODO: https://example.com](TODO: https://example.com)
  <br>Citation: TODO: Author et al. (YEAR)
  <br>License: TODO: license


## 🔄 Transformations
TODO: describe any processing, or say 'none — preserved as‑is'

## 📁 Assets

- `TODO.parquet` (Parquet): TODO: what this file contains


## 🧪 Usage
```bash
biobricks install chembl

import biobricks as bb
import pandas as pd

paths = bb.assets("chembl")

# Available assets:

df_1 = pd.read_parquet(paths.TODO_parquet)


print(df_1.head())      # Preview the first asset

## Additional Information
# chembl

## 🔍 Overview
TODO: one‑sentence plain‑language description.

## 📦 Data Source

- **TODO: data source name**  
  URL: [TODO: https://example.com](TODO: https://example.com)
  <br>Citation: TODO: Author et al. (YEAR)
  <br>License: TODO: license


## 🔄 Transformations
TODO: describe any processing, or say 'none — preserved as‑is'

## 📁 Assets

- `TODO.parquet` (Parquet): TODO: what this file contains


## 🧪 Usage
```bash
biobricks install chembl

import biobricks as bb
import pandas as pd

paths = bb.assets("chembl")

# Available assets:

df_1 = pd.read_parquet(paths.TODO_parquet)


print(df_1.head())      # Preview the first asset

## Additional Information
# chembl
<a href="https://github.com/biobricks-ai/chembl/actions"><img src="https://github.com/biobricks-ai/chembl/actions/workflows/bricktools-check.yaml/badge.svg?branch=master"/></a>

## Description
> A manually curated database of bioactive molecules with drug-like properties

# Usage
```{R}
biobricks::install_brick("chembl")
biobricks::brick_pull("chembl")
biobricks::brick_load("chembl")
```

# Documentation

https://chembl.gitbook.io/chembl-interface-documentation/downloads
