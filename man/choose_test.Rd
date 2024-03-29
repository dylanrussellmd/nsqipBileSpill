% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/comparison.R
\name{choose_test}
\alias{choose_test}
\title{Choose the correct statistical test}
\usage{
choose_test(df, group, col)
}
\arguments{
\item{df}{a data frame}

\item{group}{a grouping variable to split the records in \code{col} and test by.}

\item{col}{a column to be tested}
}
\value{
a list of class \code{htest} representing the results of either \code{chisq.test} or \code{t.test}
}
\description{
Selects the correct statistical test for a provided dataframe column.
}
\details{
currently does not work with factors, only logicals and numerics.
}
\examples{
mtcars \%>\% dplyr::group_by(hp > 150) \%>\% choose_test(`hp > 150`, mpg)

}
