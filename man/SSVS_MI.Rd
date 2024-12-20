% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SSVS_MI.R
\name{SSVS_MI}
\alias{SSVS_MI}
\title{Perform SSVS on Multiply Imputed Datasets}
\usage{
SSVS_MI(
  data,
  y,
  x,
  imputations = 25,
  replications = 500,
  interval = 0.9,
  continuous = TRUE,
  progress = FALSE
)
}
\arguments{
\item{data}{A dataframe containing the variables of interest, including an \code{.imp} column for imputation identifiers
and an \code{r} column for replication identifiers.}

\item{y}{The response variable (character string).}

\item{x}{A vector of predictor variable names.}

\item{imputations}{The number of imputations to process (default is 25).}

\item{replications}{The number of replications per imputation (default is 500).}

\item{interval}{Confidence interval level for summary results (default is 0.9).}

\item{continuous}{Logical indicating if the response variable is continuous (default is TRUE).}

\item{progress}{Logical indicating whether to display progress (default is FALSE).}
}
\value{
An SSVS object containing aggregated results across imputations and replications, including mean
inclusion probabilities and average beta coefficients for each predictor.
}
\description{
This function performs Stochastic Search Variable Selection (SSVS) analysis on multiply imputed datasets
for a given set of predictors and a response variable. It supports continuous response variables and calculates
aggregated results across multiple imputations and replications.
}
\examples{
\donttest{
data(example_data)
outcome <- "yMCAR40"
predictors <- c("xMCAR40_1", "xMCAR40_2", "xMCAR40_3", "xMCAR40_4", "xMCAR40_5")
results <- SSVS_MI(data = example_data, y = outcome, x = predictors, imputations = 3, replications = 3)
}
}
