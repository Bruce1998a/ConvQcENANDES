
#' Guardar resultados en CSV, XLSX o TXT
#' @param data Tibble resultante
#' @param formato 'csv','xlsx' o 'txt'
#' @param nombre Nombre base del archivo (sin extensión)
#' @return TRUE (invisible)
#' @examples
#' # guardar_resultados(d, 'csv', 'resultado')
guardar_resultados <- function(data, formato = c("csv","xlsx","txt"), nombre = "resultado"){
  formato <- match.arg(formato)
  if(formato == "csv"){
    readr::write_csv(data, paste0(nombre,".csv"))
  } else if(formato == "xlsx"){
    writexl::write_xlsx(data, paste0(nombre,".xlsx"))
  } else {
    readr::write_delim(data, paste0(nombre,".txt"), delim = "\t")
  }
  invisible(TRUE)
}
