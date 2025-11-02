
#' Detección de atípicos mediante PCA
#' @param data DataFrame con columna 'valor'
#' @param n_comp Número de componentes principales
#' @param percentil Umbral de percentil
#' @return DataFrame con columna 'atipico_pca'
pca_outliers <- function(data, n_comp=2, percentil=0.99){
  if(!requireNamespace("stats", quietly=TRUE)){
    stop("Paquete 'stats' requerido.")
  }
  pca <- prcomp(data.frame(valor=data$valor), scale.=TRUE)
  dist <- sqrt(rowSums((pca$x[,1:min(n_comp, ncol(pca$x))])^2))
  umbral <- quantile(dist, probs=percentil)
  data$atipico_pca <- dist > umbral
  return(data)
}
