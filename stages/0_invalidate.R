# invalidate the dvc cache when the chembl checksum changes
pacman::p_load(fs)
hst <- "ftp://ftp.ebi.ac.uk/"
url <- fs::path(hst,"pub/databases/chembl/ChEMBLdb/latest/checksums.txt")
chk <- fs::dir_create("staging") |> fs::path("checksums.txt")
download.file(url, chk)