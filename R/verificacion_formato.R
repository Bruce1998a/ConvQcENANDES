#' Verificación de formato (fecha d/m/Y y valor) y rango temporal
#'
#' Requiere columnas: `fecha` (carácter "dd/mm/yyyy") y `valor` (numérico).
#' - Parseo de fecha con `lubridate::dmy`
#' - Validación de cobertura [fecha_inicio, fecha_fin]
#' - Marca duplicados y faltantes en la secuencia diaria
#' @param data Data frame con columnas `fecha`, `valor`.
#' @param variable 1=precipitación, 2=Tmedia, 3=Tmax, 4=Tmin.
#' @param fecha_inicio "dd/mm/yyyy".
#' @param fecha_fin "dd/mm/yyyy".
#' @return Tibble con columnas: fecha, valor, duplicado, faltante, variable, variable_nombre.
#' @export
verificacion_formato <- function(data, variable, fecha_inicio, fecha_fin) {
  stopifnot(all(c("fecha","valor") %in% names(data)))
  f <- suppressWarnings(lubridate::dmy(data$fecha))
  if (any(is.na(f))) stop("Error: formato de 'fecha' inválido. Use 'dd/mm/yyyy'.")
  if (!.is_numeric(data$valor)) stop("Error: 'valor' debe ser numérico.")

  ini <- suppressWarnings(lubridate::dmy(fecha_inicio))
  fin <- suppressWarnings(lubridate::dmy(fecha_fin))
  if (is.na(ini) || is.na(fin) || ini > fin) {
    stop("Error en fechas de inicio/fin. Formato 'dd/mm/yyyy' y asegure inicio <= fin.")
  }

  minf <- min(f, na.rm = TRUE)
  maxf <- max(f, na.rm = TRUE)
  if (minf > ini || maxf < fin) {
    stop(sprintf("Las fechas inicial y final NO coinciden con tus datos. Rango datos: %s a %s.",
                 format(minf, "%d/%m/%Y"), format(maxf, "%d/%m/%Y")))
  }

  full_seq <- seq(ini, fin, by = "day")
  dup <- duplicated(f) | duplicated(f, fromLast = TRUE)

  d <- tibble::tibble(
    fecha = f,
    valor = as.numeric(data$valor),
    duplicado = dup
  ) |>
    dplyr::arrange(fecha)

  d$variable <- as.integer(variable)
  d$variable_nombre <- var_name(variable)

  d <- dplyr::right_join(
    d,
    tibble::tibble(fecha = full_seq),
    by = "fecha"
  ) |>
    dplyr::mutate(
      faltante = is.na(valor),
      duplicado = dplyr::coalesce(duplicado, FALSE)
    ) |>
    dplyr::arrange(fecha)

  d
}
