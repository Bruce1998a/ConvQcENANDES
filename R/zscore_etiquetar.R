
#' Detección de atípicos por Z-score
#' @param data DataFrame con columna 'valor'
#' @param variable Tipo de variable
#' @param percentil Umbral de percentil (0.95, 0.99)
#' @return DataFrame con columna 'atipico_zscore'
zscore_etiquetar <- function(data, variable, percentil=0.99){
  z <- (data$valor - mean(data$valor, na.rm=TRUE)) / sd(data$valor, na.rm=TRUE)
  limite <- qnorm(percentil)
  data$atipico_zscore <- abs(z) > limite
  return(data)
}
