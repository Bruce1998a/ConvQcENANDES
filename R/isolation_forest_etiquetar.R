
#' Detección de atípicos por Isolation Forest
#' @param data Tibble con columna `valor`
#' @param contaminacion Proporción esperada de atípicos (ej. 0.01)
#' @param n_arboles Número de árboles (ej. 200)
#' @param max_muestras Tamaño de muestra por árbol; "auto" usa nrow(data)
#' @param semilla Semilla reproducible (opcional)
#' @return Tibble con columnas `iso_score` y `atipico_isoforest`
#' @examples
#' df <- verificacion_formato(datos_ejemplo_convqc(),1,"01/01/2020","31/01/2020")
#' isolation_forest_etiquetar(df, 0.01, 200)
isolation_forest_etiquetar <- function(data, contaminacion = 0.01, n_arboles = 200,
                                       max_muestras = "auto", semilla = NULL){
  if(!requireNamespace("isotree", quietly = TRUE)){
    stop("Necesita instalar 'isotree' (install.packages('isotree')).")
  }
  X <- matrix(as.numeric(data$valor), ncol = 1)
  if(!is.null(semilla)) set.seed(semilla)
  if(identical(max_muestras, "auto")) max_muestras <- nrow(data)
  modelo <- isotree::isolation.forest(X, ntrees = n_arboles, sample_size = max_muestras)
  score <- isotree::predict.isolation_forest(modelo, X, type = "score")
  data$iso_score <- as.numeric(score)
  thr <- stats::quantile(data$iso_score, probs = 1 - contaminacion, na.rm = TRUE, names = FALSE)
  data$atipico_isoforest <- data$iso_score >= thr
  data
}
