#' Control de rango lógico
#' @param data Tibble de `verificacion_formato()`.
#' @param inferior Límite inferior (incluye).
#' @param superior Límite superior (incluye).
#' @param eliminar Si TRUE elimina filas fuera de rango (no elimina faltantes).
#' @return Tibble con `flag_rango`.
#' @export
rango_logico <- function(data, inferior, superior, eliminar = FALSE) {
  stopifnot(all(c("fecha","valor") %in% names(data)))
  flag <- !is.na(data$valor) & data$valor >= inferior & data$valor <= superior
  data$flag_rango <- flag
  if (isTRUE(eliminar)) {
    data <- dplyr::filter(data, flag | isTRUE(faltante))
  }
  data
}
