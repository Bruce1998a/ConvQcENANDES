
#' Verificación de formato (fecha y rango temporal)
#' @description Verifica columnas requeridas, formato de fecha dd/mm/yyyy y que el rango [inicio, fin] esté cubierto por los datos.
#' @param data data.frame con columnas `fecha` y `valor`
#' @param variable 1=Precipitación (mm); 2=Temp. media (°C); 3=Temp. máxima (°C); 4=Temp. mínima (°C)
#' @param fecha_inicio Cadena "dd/mm/yyyy"
#' @param fecha_fin Cadena "dd/mm/yyyy"
#' @return Tibble ordenado por fecha
#' @examples
#' df <- datos_ejemplo_convqc()
#' verificacion_formato(df, 1, "01/01/2020","31/01/2020")
verificacion_formato <- function(data, variable, fecha_inicio, fecha_fin){
  if(!all(c("fecha","valor") %in% names(data))) stop("Se requieren columnas 'fecha' y 'valor'.")
  f <- try(as.Date(data$fecha, format="%d/%m/%Y"), silent = TRUE)
  if(inherits(f,"try-error") || any(is.na(f))) stop("Formato de 'fecha' inválido. Use 'dd/mm/yyyy'.")
  if(!is.numeric(data$valor)) stop("'valor' debe ser numérico.")
  ini <- as.Date(fecha_inicio, "%d/%m/%Y"); fin <- as.Date(fecha_fin, "%d/%m/%Y")
  if(is.na(ini) || is.na(fin) || ini > fin) stop("Revise fecha_inicio/fecha_fin (dd/mm/yyyy) y que inicio <= fin.")
  if(min(f) > ini || max(f) < fin){
    stop(sprintf("Rango de datos %s a %s no cubre [%s, %s].",
                 format(min(f),"%d/%m/%Y"), format(max(f),"%d/%m/%Y"),
                 fecha_inicio, fecha_fin))
  }
  d <- tibble::tibble(fecha = f, valor = as.numeric(data$valor)) |> dplyr::arrange(fecha)
  d$variable <- as.integer(variable)
  d
}
