#' Autoencoder (H2O) para detección de atípicos por error de reconstrucción
#' @param data Tibble con columnas numéricas (al menos `valor`) y `fecha`.
#' @param hidden Arquitectura de capas ocultas, ej. c(8,3,8).
#' @param epochs Número de épocas (ej. 100).
#' @param percentil Percentil de error para etiquetar (ej. 0.99).
#' @param semilla Semilla reproducible.
#' @return Tibble con `ae_error` y `outlier_ae`.
#' @export
autoencoder_h2o <- function(data,
                            hidden = c(8, 3, 8),
                            epochs = 100,
                            percentil = 0.99,
                            semilla = 1234) {
  stopifnot(all(c("fecha","valor") %in% names(data)))
  num_cols <- sapply(data, is.numeric)
  X <- as.data.frame(data[, num_cols, drop = FALSE])
  ok <- complete.cases(X)
  X_ok <- X[ok, , drop = FALSE]

  if (!h2o::h2o.isRunning()) {
    h2o::h2o.init(nthreads = -1, min_mem_size = "2G")
  }

  hf <- h2o::as.h2o(X_ok, destination_frame = "ae_train")
  model <- h2o::h2o.deeplearning(
    x = colnames(hf),
    training_frame = hf,
    autoencoder = TRUE,
    hidden = hidden,
    epochs = epochs,
    seed = semilla,
    reproducible = FALSE,
    activation = "Tanh",
    l1 = 0, l2 = 0
  )

  recon_err <- as.data.frame(h2o::h2o.anomaly(model, hf))[, 1]

  out <- data
  out$ae_error <- NA_real_
  out$ae_error[which(ok)] <- recon_err

  thr <- stats::quantile(out$ae_error, probs = percentil, na.rm = TRUE, names = FALSE)
  out$outlier_ae <- !is.na(out$ae_error) & out$ae_error > thr

  attr(out, "ae_model_id") <- model@model_id
  out
}
