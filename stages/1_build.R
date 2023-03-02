pacman::p_load(fs,purrr,RCurl,stringr,RSQLite,dplyr)

# delete "brick" directory if it exists
dir_del_create <- \(p){ if(dir_exists(p)) dir_delete(p); dir_create(p) }
tmp <- dir_del_create("tmp")
brk <- dir_del_create("brick")

# find the sqlite file in the chembldb/latest dir
url <- "ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/latest/"
pth <- RCurl::getURL(url, dirlistonly=T) |> strsplit("\n") |> unlist()
sql <- fs::path(url,pth[str_detect(pth,"sqlite.tar.gz")])

# throw an error if there is not exactly 1 sqlite file
if (length(sql) == 0) stop("no sqlite file found")
if (length(sql) > 1) stop("More than one sqlite file found")

# download and unzip the file
options(timeout=1800)
tgt <- fs::path(tmp,"sqlite.tar.gz")
download.file(sql,tgt)
untar(tgt, exdir=tmp)
sdb <- fs::dir_ls(tmp,recurse=T,regexp="chembl_[0-9]+.db")

# build parquet tables
chembl  <- DBI::dbConnect(RSQLite::SQLite(),sdb)
tables  <- DBI::dbListTables(chembl)

# Define the chunk size
purrr::walk(tables,\(name){
  cat("writing",name,"...\n")
  chunk_size <- 1e7
  stmt <- DBI::dbSendQuery(chembl, sprintf("SELECT * FROM %s",name))
  tblp <- fs::dir_create(brk,name,ext="parquet")
  while (TRUE) {
    chunk <- dbFetch(stmt, n = chunk_size)
    if (nrow(chunk) == 0) { break }
    chunkpath <- fs::path(tblp,sprintf("%s.parquet",uuid::UUIDgenerate()))
    arrow::write_parquet(chunk, chunkpath)
    cat(".")
  }
  DBI::dbClearResult(stmt)
  print(sprintf("Wrote %s to %s",name,tblp))
})

# Cleanup, disconnect and delete tmp
DBI::dbDisconnect(chembl)
fs::dir_delete("tmp")