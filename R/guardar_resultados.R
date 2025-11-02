
#' Guardar resultados de control de calidad
#' @param data DataFrame resultante
#' @param formato 'csv', 'xlsx' o 'txt'
#' @param nombre nombre base del archivo
guardar_resultados <- function(data, formato='csv', nombre='resultado'){
  if(formato=='csv'){
    readr::write_csv(data, paste0(nombre,'.csv'))
  } else if(formato=='xlsx'){
    writexl::write_xlsx(data, paste0(nombre,'.xlsx'))
  } else if(formato=='txt'){
    write.table(data, paste0(nombre,'.txt'), sep='\t', row.names=FALSE)
  } else {
    stop("Formato no reconocido.")
  }
}
