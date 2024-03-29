% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{first_valid_regex}
\alias{first_valid_regex}
\title{a row operation that will form a vector of the first match of a pattern.}
\usage{
first_valid_regex(data, colvec, pattern)
}
\arguments{
\item{data}{input data}

\item{colvec}{selected columns to match}

\item{pattern}{the pattern to match}
}
\value{
return the vector of the matched characters with NA for a no match
}
\description{
a row operation that will form a vector of the first match of a pattern.
}
\examples{
dat <- data.frame(x1 = letters[1:3], x2 = c("d", "a", "e"))
library(dplyr)
library(purrr)
dat \%>\% mutate(x3 = first_valid_regex(., colvec = c(1:2), pattern = "a"))

}
