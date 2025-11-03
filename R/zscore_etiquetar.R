
#' Detección de atípicos por Z-score
#' @description Para `variable==1` (precipitación) usa Z-score modificado (mediana/MAD). Para temperaturas (2–4) usa Z-score clásico.
#' @param data Tibble con columna `valor`
#' @param variable 1=Precipitación; 2=Temp. media; 3=Temp. máx.; 4=Temp. mín.
#' @param percentil Percentil de |Z| para etiquetar (ej. 0.99)
#' @return Tibble con columnas `zscore` y `atipico_zscore`
#' @examples
#' df <- verificacion_formato(datos_ejemplo_convqc(),1,"01/01/2020","31/01/2020")
#' zscore_etiquetar(df, 1, 0.99)
zscore_etiquetar <- function(data, variable, percentil = 0.99){
  x <- data$valor
  if(as.integer(variable) == 1){
    med <- stats::median(x, na.rm=TRUE); mad <- stats::mad(x, constant = 1, na.rm=TRUE)
    z <- ifelse(mad==0, NA_real_, 0.6745*(x - med)/mad)
  } else {
    mu <- mean(x, na.rm=TRUE); sdv <- stats::sd(x, na.rm=TRUE)
    z <- ifelse(isTRUE(sdv==0) || is.na(sdv), NA_real_, (x - mu)/sdv)
  }
  thr <- stats::quantile(abs(z), probs = percentil, na.rm = TRUE, names = FALSE)
  data$zscore <- z
  data$atipico_zscore <- ifelse(is.na(z), FALSE, abs(z) > thr)
  data
}
