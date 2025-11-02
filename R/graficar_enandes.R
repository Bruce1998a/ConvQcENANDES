
#' Gráficos básicos de control de calidad
#' @param data DataFrame con columnas 'fecha' y 'valor'
#' @param tipo Tipo de gráfico (1=Boxplot, 2=Serie temporal, 3=Atípicos)
graficar_enandes <- function(data, tipo=1){
  if(!requireNamespace("ggplot2", quietly=TRUE)) stop("Se requiere ggplot2.")
  library(ggplot2)
  if(tipo==1){
    ggplot(data, aes(y=valor)) + geom_boxplot(fill='skyblue') + theme_minimal()
  } else if(tipo==2){
    ggplot(data, aes(x=fecha, y=valor)) + geom_line(color='blue') + theme_minimal()
  } else {
    ggplot(data, aes(x=fecha, y=valor, color=validacion)) + geom_point(size=2) + theme_minimal()
  }
}
