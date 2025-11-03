
#' Gráficos de control de calidad
#' @param data Tibble con `fecha` y `valor`
#' @param tipo 1=Boxplot; 2=Serie; 3=Serie con atípicos Z; 4=Serie con atípicos ISO
#' @return ggplot
#' @examples
#' d <- datos_ejemplo_convqc() |> verificacion_formato(1,"01/01/2020","31/01/2020")
#' graficar_enandes(d, 2)
graficar_enandes <- function(data, tipo = 2){
  if(!requireNamespace("ggplot2", quietly=TRUE)) stop("Se requiere 'ggplot2'.")
  library(ggplot2)
  if(tipo == 1){
    ggplot(data, aes(y = valor)) + geom_boxplot() + labs(y = "Valor", x = NULL)
  } else if(tipo == 2){
    ggplot(data, aes(fecha, valor)) + geom_line() + geom_point() + labs(x = "Fecha", y = "Valor")
  } else if(tipo == 3){
    if(!"atipico_zscore" %in% names(data)) stop("Ejecute zscore_etiquetar() primero.")
    ggplot(data, aes(fecha, valor, color = atipico_zscore)) + geom_line() + geom_point() + labs(color = "Atípico Z")
  } else if(tipo == 4){
    if(!"atipico_isoforest" %in% names(data)) stop("Ejecute isolation_forest_etiquetar() primero.")
    ggplot(data, aes(fecha, valor, color = atipico_isoforest)) + geom_line() + geom_point() + labs(color = "Atípico ISO")
  } else {
    stop("Tipo desconocido. Use 1..4.")
  }
}
