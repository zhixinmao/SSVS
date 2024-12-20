#' Example Data for SSVS-MI Analysis
#'
#' A dataset with 45 rows and 9 variables used for demonstrating the
#' `SSVS_MI` function.
#'
#' @format A data frame with 45 rows and 9 variables:
#' \describe{
#'   \item{.imp}{Imputation identifier (1 to 3).}
#'   \item{.id}{ID identifier (1 to 5).}
#'   \item{r}{Replication identifier (1 to 3).}
#'   \item{yMCAR40}{Response variable.}
#'   \item{xMCAR40_1}{Predictor variable 1.}
#'   \item{xMCAR40_2}{Predictor variable 2.}
#'   \item{xMCAR40_3}{Predictor variable 3.}
#'   \item{xMCAR40_4}{Predictor variable 4.}
#'   \item{xMCAR40_5}{Predictor variable 5.}
#' }
#'
#' @examples
#' data(example_data)
#' outcome <- "yMCAR40"
#' predictors <- c("xMCAR40_1", "xMCAR40_2", "xMCAR40_3", "xMCAR40_4", "xMCAR40_5")
#' results <- SSVS_MI(data = example_data, y = outcome, x = predictors, imputations = 3, replications = 3)
"example_data"
