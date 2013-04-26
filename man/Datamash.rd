\name{Datamash}
\alias{Datamash}
\title{Interacts with the DatamashIO API}
\usage{
  Datamash.read(url, version)
}
\arguments{
  \item{url}{URL to source data from.}

  \item{version}{Use to retrieve a version, will query from archive not URL.}
}
\value{
  Returns a list of resource objects. Slot data contains a data.frame.
}
\description{
  An API key is required for access to the DatamashIO API.
  Set your \code{api_key} woth \code{Datamash.auth} function.
}
\details{
  For instructions on finding your API key goto https://datamash.io
}
\examples{
\dontrun{
respositories = Datamash.read("http://www.bbc.com/news")
}
}
\author{
  Bjoern Stiel
}
\references{
  This R package uses the DatamashIO API. For more information
  go to https://datamash.io.
}
\seealso{
  \code{\link{Datamash.auth}}
}
