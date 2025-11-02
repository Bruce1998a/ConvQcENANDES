#' Z-score (modificado para precipitación; estándar para temperaturas)
#'
#' Precipitación (variable==1): Z_mod = 0.6745*(x - mediana)/MAD.
#' Temperaturas (2–4): Z = (x - media)/sd.
#' Atípico si |Z| excede el percentil de |Z| definido por usuario.
#' @param data Tibble con `valor`.
#' @param variable 1=precipitación, 2=Tmedia, 3=Tmax, 4=Tmin.
#' @param percentil Percentil de |Z| (ej. 0.99).
#' @return Tibble con `zscore` y `outlier_z`.
#' @export
zscore_etiquetar <- function(data, variable, percentil = 0.99) {
  x <- data$valor
  z <- rep(NA_real_, length(x))
  if (as.integer(variable) == 1) {
    med <- stats::median(x, na.rm = TRUE)
    mad <- stats::mad(x, constant = 1, na.rm = TRUE)
    if (mad == 0) z <- NA_real_ else z <- 0.6745 * (x - med) / mad
  } else {
    mu <- mean(x, na.rm = TRUE)
    sdv <- stats::sd(x, na.rm = TRUE)
    if (isTRUE(sdv == 0) || is.na(sdv)) z <- NA_real_ else z <- (x - mu) / sdv
  }
  thr <- stats::quantile(abs(z), probs = percentil, na.rm = TRUE, names = FALSE)
  data$zscore <- z
  data$outlier_z <- ifelse(is.na(z), FALSE, abs(z) > thr)
  data
}
