#' Construir columna de validación global
#' Combina: flag_rango (si existe), outlier_z (si existe), outlier_iso (si existe) y duplicado.
#' No penaliza `faltante` (se marca aparte).
#' @export
construir_validacion <- function(data) {
  vr <- if ("flag_rango" %in% names(data)) data$flag_rango else TRUE
  vz <- if ("outlier_z" %in% names(data)) !data$outlier_z else TRUE
  vi <- if ("outlier_iso" %in% names(data)) !data$outlier_iso else TRUE
  data$validacion <- vr & vz & vi & !isTRUE(data$duplicado)
  data
}
