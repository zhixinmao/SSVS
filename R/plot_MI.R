#' Plot SSVS-MI Estimates and Marginal Inclusion Probabilities (MIP)
#'
#' This function creates a plot of SSVS-MI estimates with minimum and maximum.
#'
#' @param data A data frame containing summary statistics for SSVS results. Must include columns:
#'   \describe{
#'     \item{Variable}{The predictor variables.}
#'     \item{Avg Beta}{The average beta coefficients across imputations or replications.}
#'     \item{Min Beta}{The minimum beta coefficients.}
#'     \item{Max Beta}{The maximum beta coefficients.}
#'   }
#' @param title A character string specifying the plot title. Defaults to `"SSVS-MI estimates"`.
#' @return A `ggplot2` object representing the plot of SSVS estimates.
#' @examples
#' \donttest{
#' data(imputed_mtcars)
#' outcome <- 'qsec'
#' predictors <- c('cyl', 'disp', 'hp', 'drat', 'wt', 'vs', 'am', 'gear', 'carb','mpg')
#' imputation <- '.imp'
#' results <- ssvs_mi(data = imputed_mtcars, y = outcome, x = predictors, imp = imputation)
#' summary_MI <- summary.mi(results)
#' plot.est(summary_MI)
#' }
#' @export
plot.est <- function(data, title=NULL) {
  checkmate::assert_data_frame(data, min.cols = 4)
  checkmate::assert_string(title, null.ok = TRUE)

  if (is.null(title)) {
    title <- "SSVS-MI estimates"
  }

  plt <- ggplot2::ggplot(data, ggplot2::aes(x = forcats::fct_inorder(Variable),
                                            y = .data[['Avg Beta']])) +
      ggplot2::geom_errorbar(
        ggplot2::aes(ymin = .data[['Min Beta']], ymax = .data[['Max Beta']]),
        position = "dodge", width = 0.2
      ) +
      ggplot2::geom_point() +
      ggplot2::labs(
        title = title,
        x = "Variables",
        y = "Mean Coefficients"
      ) +
      ggplot2::theme_classic()

  plt
}


#' Creates a plot for marginal inclusion probabilities (MIP) optional thresholds for highlighting significant predictors.
#'
#' @param data A data frame containing MIP summary statistics. Must include columns:
#'   \describe{
#'     \item{Variable}{The predictor variables.}
#'     \item{Avg MIP}{The average MIP values across imputations or replications.}
#'     \item{Min MIP}{The minimum MIP values.}
#'     \item{Max MIP}{The maximum MIP values.}
#'   }
#' @param threshold A numeric value (between 0 and 1) specifying the MIP threshold to highlight significant predictors.
#'   Defaults to 0.5.
#' @param legend Logical indicating whether to include a legend for the threshold. Defaults to `TRUE`.
#' @param title A character string specifying the plot title. Defaults to `"Multiple Inclusion Probability for SSVS-MI"`.
#' @param color Logical indicating whether to use color to highlight thresholds. Defaults to `TRUE`.
#' @return A `ggplot2` object representing the plot of MIP with thresholds.
#' @examples
#' \donttest{
#' # Example using imputed data
#' data(imputed_mtcars)
#' outcome <- "qsec"
#' predictors <- c("cyl", "disp", "hp", "drat", "wt", "vs", "am", "gear", "carb", "mpg")
#' imputation <- ".imp"
#' results <- ssvs_mi(data = imputed_mtcars, y = outcome, x = predictors, imp = imputation)
#' summary_MI <- summary.mi(results)
#' plot.mip(summary_MI)
#' }
#' @export
plot.mip <- function(data, threshold = 0.5, legend = TRUE, title = NULL, color = TRUE) {
  checkmate::assert_data_frame(data, min.cols = 4)
  checkmate::assert_number(threshold, lower = 0, upper = 1, null.ok = TRUE)
  checkmate::assert_logical(legend, len = 1, any.missing = FALSE)
  checkmate::assert_string(title, null.ok = TRUE)

  plotDF <- data %>%
    as.data.frame() %>%
    dplyr::mutate(
      avg.mip = `Avg MIP`,
      min.mip = `Min MIP`,
      max.mip = `Max MIP`
    ) %>%
    dplyr::select(Variable, avg.mip, min.mip, max.mip)
  plotDF <- plotDF[order(-plotDF$avg.mip),]

  if (is.null(threshold)) {
    plotDF$threshold <- as.factor(0)
  } else {
    plotDF$threshold <- ifelse(plotDF$avg.mip > threshold, 1, 0)
    plotDF$threshold <- factor(plotDF$threshold, levels = c(0, 1))
    levels(plotDF$threshold) <- c(paste0('< ', threshold), paste0('> ', threshold))
  }

  if (is.null(title)) {
    title <- "Marginal Inclusion Probability for SSVS-MI"
  }

  if (color) {
    cols <- c("#FF4D1C", "#225C3E")
  } else {
    cols <- c("black", "black")
  }

  plt <- ggplot2::ggplot(data = plotDF) +
    ggplot2::geom_point(ggplot2::aes(x = stats::reorder(.data[["Variable"]], -.data[["avg.mip"]]),
                                     y = .data[["avg.mip"]],
                                     shape = .data[["threshold"]],
                                     color = .data[["threshold"]]),
                        size = 2) +
    ggplot2::geom_errorbar(ggplot2::aes(x = .data[["Variable"]],
                               y = .data[["avg.mip"]],
                               ymin = .data[["min.mip"]],
                               ymax = .data[["max.mip"]]),
                           width = .10,
                           position = "dodge") +
    ggplot2::labs(y = "Marginal Inclusion Probability",
                  x = "Predictor variables",
                  title = title) +
    ggplot2::scale_y_continuous(limits = c(0,1.1), breaks = c(0, .25, .5, .75, 1)) +
    ggplot2::scale_color_manual(values = cols) +
    ggplot2::theme_classic() +
    ggplot2::geom_vline(xintercept = nrow(plotDF)+.5, linetype = 1, size = .5, alpha = .2) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1),
                   panel.spacing = ggplot2::unit(0, "lines"),
                   strip.background = ggplot2::element_blank(),
                   strip.placement = "outside")

  if (!is.null(threshold)) {
    plt <- plt +
      ggplot2::labs(shape = "MIP threshold", color = "MIP threshold") +
      ggplot2::geom_hline(yintercept = threshold, linetype = 2)
    if (legend) {
      plt <- plt + ggplot2::guides(shape = "legend", color = "legend")
    } else {
      plt <- plt + ggplot2::guides(shape = "none", color = "none")  # Correctly disable the legends using "none"
    }
  }

  plt
}







