
#' Cargar datos de ejemplo (enero 2020)
#' @description Retorna un data.frame con columnas `fecha` (dd/mm/yyyy) y `valor` (numérico).
#' @return data.frame
#' @examples
#' df <- datos_ejemplo_convqc()
datos_ejemplo_convqc <- function(){
  f <- system.file("extdata","ejemplo_convqc.csv", package = "ConvQcENANDES")
  readr::read_csv(f, show_col_types = FALSE)
}
