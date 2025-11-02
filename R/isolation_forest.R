#' Isolation Forest para detección de atípicos
#' @param data Tibble con `valor`.
#' @param contaminacion Proporción esperada de atípicos (ej. 0.01).
#' @param n_arboles Número de árboles (ej. 200).
#' @param max_muestras Tamaño de muestra por árbol; "auto" usa nrow(data).
#' @param semilla Semilla reproducible.
#' @return Tibble con `iso_score` y `outlier_iso`.
#' @export
isolation_forest_etiquetar <- function(data, contaminacion = 0.01,
                                       n_arboles = 200,
                                       max_muestras = "auto",
                                       semilla = NULL) {
  stopifnot("valor" %in% names(data))
  x <- as.numeric(data$valor)
  X <- matrix(x, ncol = 1)
  if (!is.null(semilla)) set.seed(semilla)
  if (identical(max_muestras, "auto")) max_muestras <- nrow(data)

  modelo <- isotree::isolation.forest(
    X, ntrees = n_arboles, sample_size = max_muestras
  )
  score <- isotree::predict.isolation_forest(modelo, X, type = "score")
  data$iso_score <- as.numeric(score)

  thr <- stats::quantile(data$iso_score, probs = 1 - contaminacion, na.rm = TRUE, names = FALSE)
  data$outlier_iso <- data$iso_score >= thr
  data
}
