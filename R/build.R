library(fs)
library(rvest)
library(purrr)
cache_dir = "cache"
data_dir = "data"
fs::dir_create(cache_dir)
fs::dir_create(data_dir)
options(timeout=1800)

# note: do not use https, too slow
#url <- "https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest" # nolint

host <- "ftp://ftp.ebi.ac.uk"
dir <- "/pub/databases/chembl/ChEMBLdb/latest"
file <- "chembl_30_sqlite.tar.gz"
download.file(destfile=file.path(cache_dir,file),url=file.path(host,dir,file))
# uncompress it
sqlite_tar_gz_file <- list.files(cache_dir) |> pluck(1)
sqlite_tar_gz_path <- file.path(cache_dir,file)
untar(sqlite_tar_gz_path,exdir=cache_dir)
sqlite_extracted_dir <- list.dirs(cache_dir) |> keep(~ grepl("sqlite",.x))
sqlite_db_file <- sqlite_extracted_dir |> list.files() |> keep(~ grepl("db",.x))
sqlite_db_path <- file.path(sqlite_extracted_dir,sqlite_db_file)
# copy the file over
fs::file_move(sqlite_db_path,file.path(data_dir))
