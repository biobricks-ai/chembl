library(dplyr)
library(purrr)

out     <- fs::dir_create("data/parquet")
chembl  <- DBI::dbConnect(RSQLite::SQLite(),"data/chembl_30.db")
tables  <- DBI::dbListTables(chembl)

purrr::walk(tables,\(name){
  cat("writing",name,"...\n")
  path   <- fs::dir_create(out,name,ext="parquet")
  tbl(chembl,name) |> arrange(1) |> 
    mutate(chunk=floor(row_number()/1e7)) |> group_by(chunk) |> 
    collect() |> 
    arrow::write_dataset(path)
})

DBI::dbDisconnect(chembl)
