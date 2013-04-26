#' Datamash.Resource class
setClass("Datamash.Resource",
  representation(
    id="character",
    name="character",
    full_name="character",
    schema="list",
    number_of_records="numeric",
    repository="character",
    version="numeric",
    data="ANY")
)