
#' Consolidar validación de controles
#' @description Combina resultados de los controles lógicos y estadísticos
#' @return DataFrame con columna 'validacion'
construir_validacion <- function(data){
  vars <- c('fuera_rango','atipico_zscore','atipico_isoforest','atipico_pca')
  presentes <- intersect(vars, names(data))
  data$validacion <- !apply(data[,presentes,drop=FALSE], 1, any)
  return(data)
}
