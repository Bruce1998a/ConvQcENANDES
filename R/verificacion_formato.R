
#' Verificación de formato de fechas y estructura
#' @description Verifica que las fechas tengan formato correcto (día/mes/año) y coincidan con el rango temporal indicado.
#' @param data DataFrame con columnas 'fecha' y 'valor'
#' @param variable Tipo de variable: 1=Precipitación, 2=Temperatura media, 3=Máxima, 4=Mínima
#' @param fecha_inicio Fecha inicial (formato 'dd/mm/yyyy')
#' @param fecha_fin Fecha final (formato 'dd/mm/yyyy')
#' @return DataFrame con fechas y valores validados
verificacion_formato <- function(data, variable, fecha_inicio, fecha_fin){
  if(!all(c('fecha', 'valor') %in% names(data))){
    stop("El dataset debe contener las columnas 'fecha' y 'valor'.")
  }
  data$fecha <- as.Date(data$fecha, format="%d/%m/%Y")
  if(any(is.na(data$fecha))) stop("Error en el formato de fechas (use dd/mm/yyyy).")
  f1 <- as.Date(fecha_inicio, format="%d/%m/%Y")
  f2 <- as.Date(fecha_fin, format="%d/%m/%Y")
  if(min(data$fecha) > f1 | max(data$fecha) < f2){
    stop("Las fechas del dataset no coinciden con el rango indicado.")
  }
  return(data)
}
