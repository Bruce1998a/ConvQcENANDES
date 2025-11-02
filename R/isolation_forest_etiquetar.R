
#' Detección de atípicos mediante Isolation Forest
#' @param data DataFrame con columna 'valor'
#' @param contaminacion Proporción de anomalías esperadas (0.01 = 1%)
#' @param n_arboles Número de árboles
#' @return DataFrame con columna 'atipico_isoforest'
isolation_forest_etiquetar <- function(data, contaminacion=0.01, n_arboles=200){
  if(!requireNamespace("isotree", quietly=TRUE)){
    stop("Debe instalar el paquete 'isotree'.")
  }
  modelo <- isotree::isolation.forest(matrix(data$valor, ncol=1), ntrees=n_arboles, sample_size='auto')
  puntajes <- predict(modelo, matrix(data$valor, ncol=1))
  umbral <- quantile(puntajes, probs=1-contaminacion)
  data$atipico_isoforest <- puntajes > umbral
  return(data)
}
