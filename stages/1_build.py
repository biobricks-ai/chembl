from pathlib import Path
import shutil
import urllib.request
import tarfile
import sqlite3
import uuid
import pandas as pd
from ftplib import FTP

tmpdir = Path("tmp")
tmpdir.mkdir(exist_ok=True)

brkdir = Path("brick")
brkdir.mkdir(exist_ok=True)

# Download SQLite file
ftp = FTP('ftp.ebi.ac.uk')
ftp.login()
ftp.cwd('/pub/databases/chembl/ChEMBLdb/latest/')
sql = [f"ftp://ftp.ebi.ac.uk{ftp.pwd()}/{file}" for file in ftp.nlst() if file.endswith("sqlite.tar.gz")]

if len(sql) != 1:
    raise Exception(f"Expected 1 SQLite file, found {len(sql)}")

tgt = tmpdir / "sqlite.tar.gz"
urllib.request.urlretrieve(sql[0], tgt)
with tarfile.open(tgt, "r:gz") as tar:
    tar.extractall(path=tmpdir)

sqlite_path = next(tmpdir.rglob("chembl_*.db"))

# Save SQLite DB to brick directory
shutil.copy(sqlite_path, brkdir / sqlite_path.name)

shutil.rmtree(tmpdir)