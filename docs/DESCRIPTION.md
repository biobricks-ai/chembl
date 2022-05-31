This directory contains data that was obtained from [chembl](https://chembl.gitbook.io/chembl-interface-documentation/downloads)

The [ChEMBLdb](https://www.ebi.ac.uk/chembl/) is stored as a sqlite file. Within the sqlite file are 80 tables. It is suggested to explore this
data using the sqlite interface for your programming language.

# Data Retrieval

You will need dvc installed in order to retrieve the data.

To retrieve the chembldb sqlite file: 
```
dvc get git@github.com:insilica/oncindex-bricks.git bricks/chembl/data/chembl_30.db -o data/chembl_30.db
```

### It is advised to import the files into a project so that you will able to track changes in the dataset
```
dvc import git@github.com:insilica/oncindex-bricks.git bricks/chembl/data/chembl_30.db -o data/chembl_30.db
```

Then follow the instructions to save the data into your local dvc repo

# Citing ChEMBL
ChEMBL: towards direct deposition of bioassay data.
Mendez D, Gaulton A, Bento AP, Chambers J, De Veij M, Félix E, Magariños MP, Mosquera JF, Mutowo P, Nowotka M, Gordillo-Marañón M, Hunter F, Junco L, Mugumbate G, Rodriguez-Lopez M, Atkinson F, Bosc N, Radoux CJ, Segura-Cabrera A, Hersey A, Leach AR.

— Nucleic Acids Res. 2019; 47(D1):D930-D940. doi: 10.1093/nar/gky1075

ChEMBL web services: streamlining access to drug discovery data and utilities.
Davies M, Nowotka M, Papadatos G, Dedman N, Gaulton A, Atkinson F, Bellis L, Overington JP.

— Nucleic Acids Res. 2015; 43(W1):W612-20. doi: 10.1093/nar/gkv352