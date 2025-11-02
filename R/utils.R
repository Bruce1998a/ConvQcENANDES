#' @keywords internal
var_name <- function(variable) {
  switch(as.integer(variable),
         "Precipitacion (mm)", "Temperatura media (°C)",
         "Temperatura maxima (°C)", "Temperatura minima (°C)")
}

#' @keywords internal
.is_numeric <- function(x) is.numeric(x) && !is.factor(x)
