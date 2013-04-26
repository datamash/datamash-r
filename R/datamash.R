Datamash.base_url <- "https://datamash.io:443/kowalski"
Datamash.api_key <- NA



#' DatamashIO API call
#' @param url DatamashIO API endpoint \code{url}.
#' @param url HTTP \code{method}.
Datamash.http <- function(url, method='GET') {
  getURL(URLencode(url), userpwd=get("Datamash.api_key", envir=.GlobalEnv))
}


Datamash.as.dataframe <- function(l, schema) {
  record_count <- length(l)
  column_count <- length(schema)
  column_names <- names(schema)
  df <- data.frame(t(rep(NA, column_count)))
  names(df) <- column_names
  df[record_count, ] <- rep(NA, column_count)
  for(i in 1:record_count) {
    for(j in 1:column_count){
      value <- l[[i]][[column_names[j]]]
      df[column_names[j]][i,1] <- if(is.null(value)) NA else value
    } 
  }
  return(df)
}

#' Retrieve or set DatamashIO API key
#' @param api_key Parameter to set DatamashIO \code{api_key}.
#' @examples \dontrun{
#' Datamash.auth('mysecretapikey')
#' }
#' @export
Datamash.auth <- function(api_key) {
    #if (!missing(api_key))
    #  assignInNamespace('api_key', api_key, 'Datamash')
    #invisible(Datamash:::api_key)
    assign("Datamash.api_key", api_key, envir=.GlobalEnv)
}


#' Connects to a remote URL via the DatamashIO API
#'
#' An API key is required for access to the DatamashIO API.
#' The API key can be found in your dashboard at https://datamash.io/dashboard 
Datamash.connect <- function(url, version=NA) {
  if(is.na(version)) {
    url <- paste(get("Datamash.base_url", envir=.GlobalEnv), "/repository?url=", url, sep="")
  } else {
    url <- paste(get("Datamash.base_url", envir=.GlobalEnv), "/repository/v", version, "?url=", url, sep="")
  }
  response <- Datamash.http(url)
  json <- fromJSON(response, simplify=FALSE)
  return(json$resources)
}

Datamash.history <- function(url) {
  url <- paste(get("Datamash.base_url", envir=.GlobalEnv), "/repository/history?url=", url, sep="")
  response <- Datamash.http(url)
  json <- fromJSON(response, simplify=FALSE)
  return(Datamash.as.dataframe(json, list(version="Numeric",timestamp="String")))
}


Datamash.read <- function(url, version=NA) {
  if(is.na(version)) {
    url <- paste(get("Datamash.base_url", envir=.GlobalEnv), "/repository/resources?url=", url, sep="")
  } else {
    url <- paste(get("Datamash.base_url", envir=.GlobalEnv), "/repository/v/", version, "/resources?url=", url, sep="")
  }
  response <- Datamash.http(url)
  json <- fromJSON(response, simplify=FALSE)
  resources <- list()
  for(i in 1:length(json)){
    resources[i] <- new("Datamash.Resource",
      id=json[[i]]$id,
      name=json[[i]]$name,
      full_name=json[[i]]$full_name,
      schema=as.list(json[[i]]$schema),
      number_of_records=json[[i]]$number_of_records,
      repository=json[[i]]$repository,
      version=as.integer(json[[i]]$version),
      data=Datamash.as.dataframe(json[[i]]$data, as.list(json[[i]]$schema))
      )
  }
  return(resources)
}