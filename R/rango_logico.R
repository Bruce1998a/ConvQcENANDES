
#' Control de rango lógico
#' @description Detecta valores fuera del rango definido por el usuario.
#' @param data DataFrame con columna 'valor'
#' @param inferior Límite inferior aceptable
#' @param superior Límite superior aceptable
#' @param eliminar TRUE para eliminar valores fuera de rango
#' @return DataFrame con columna adicional 'fuera_rango'
rango_logico <- function(data, inferior, superior, eliminar=FALSE){
  data$fuera_rango <- data$valor < inferior | data$valor > superior
  if(eliminar){
    data <- data[!data$fuera_rango,]
  }
  return(data)
}
