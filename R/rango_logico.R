
#' Control de rango lógico
#' @param data Tibble de `verificacion_formato()`
#' @param inferior Límite inferior permitido (incluye)
#' @param superior Límite superior permitido (incluye)
#' @param eliminar Si TRUE, elimina filas fuera de rango
#' @return Tibble con columna `fuera_rango`
#' @examples
#' df <- datos_ejemplo_convqc()
#' df <- verificacion_formato(df,1,"01/01/2020","31/01/2020")
#' rango_logico(df, 0, 300)
rango_logico <- function(data, inferior, superior, eliminar=FALSE){
  data$fuera_rango <- !is.na(data$valor) & (data$valor < inferior | data$valor > superior)
  if(isTRUE(eliminar)) data <- dplyr::filter(data, !fuera_rango)
  data
}
