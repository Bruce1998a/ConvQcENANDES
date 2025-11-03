
#' Consolidar validación de controles
#' @description Combina `fuera_rango`, `atipico_zscore` y `atipico_isoforest` (si existen). TRUE = válido.
#' @return Tibble con columna `validacion`
#' @examples
#' df <- datos_ejemplo_convqc() |> verificacion_formato(1,"01/01/2020","31/01/2020")
#' df <- rango_logico(df,0,300); df <- zscore_etiquetar(df,1,0.99); df <- isolation_forest_etiquetar(df,0.01,200)
#' construir_validacion(df)
construir_validacion <- function(data){
  vars <- c("fuera_rango","atipico_zscore","atipico_isoforest")
  pres <- intersect(vars, names(data))
  if(length(pres)==0){ data$validacion <- TRUE; return(data) }
  data$validacion <- !apply(data[, pres, drop=FALSE], 1, any)
  data
}
