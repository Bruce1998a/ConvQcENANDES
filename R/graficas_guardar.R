#' Graficar resultados
#' @param data Tibble procesado.
#' @param tipo 1=boxplot; 2=serie; 3=Z-score; 4=Isolation Forest; 5=PCA; 6=Autoencoder error.
#' @export
graficar_enandes <- function(data, tipo = 2) {
  stopifnot(all(c("fecha","valor") %in% names(data)))
  library(ggplot2)
  if (tipo == 1) {
    ggplot(data, aes(y = valor)) + geom_boxplot() + labs(y = "Valor", x = NULL)
  } else if (tipo == 2) {
    ggplot(data, aes(x = fecha, y = valor)) +
      geom_line() + geom_point() + labs(x = "Fecha", y = "Valor")
  } else if (tipo == 3) {
    if (!"outlier_z" %in% names(data)) stop("Ejecuta zscore_etiquetar() primero.")
    ggplot(data, aes(fecha, valor, color = outlier_z)) +
      geom_line() + geom_point() + labs(x = "Fecha", y = "Valor", color = "Atípico Z")
  } else if (tipo == 4) {
    if (!"outlier_iso" %in% names(data)) stop("Ejecuta isolation_forest_etiquetar() primero.")
    ggplot(data, aes(fecha, valor, color = outlier_iso)) +
      geom_line() + geom_point() + labs(x = "Fecha", y = "Valor", color = "Atípico ISO")
  } else if (tipo == 5) {
    if (!all(c("PC1","PC2","outlier_pca") %in% names(data))) {
      stop("Faltan PC1/PC2/outlier_pca. Ejecuta pca_outliers().")
    }
    ggplot(data, aes(PC1, PC2, color = outlier_pca)) +
      geom_point() + labs(x = "PC1", y = "PC2", color = "Atípico PCA")
  } else if (tipo == 6) {
    if (!"ae_error" %in% names(data)) stop("Falta ae_error. Ejecuta autoencoder_h2o().")
    ggplot(data, aes(fecha, ae_error, color = outlier_ae)) +
      geom_line() + geom_point() + labs(x = "Fecha", y = "AE error", color = "Atípico AE")
  } else {
    stop("Tipo desconocido. Usa 1..6.")
  }
}

#' Guardar resultados (CSV, Excel o TXT)
#' @param data Tibble.
#' @param ruta Ruta base (con o sin extensión).
#' @param formato "csv","excel","txt".
#' @export
guardar_resultados <- function(data, ruta, formato = c("csv","excel","txt")) {
  formato <- match.arg(formato)
  if (formato == "csv") {
    readr::write_csv(data, ifelse(grepl("\.csv$", ruta), ruta, paste0(ruta, ".csv")))
  } else if (formato == "excel") {
    writexl::write_xlsx(data, ifelse(grepl("\.xlsx$", ruta), ruta, paste0(ruta, ".xlsx")))
  } else {
    readr::write_delim(data, ifelse(grepl("\.txt$", ruta), ruta, paste0(ruta, ".txt")), delim = "\t")
  }
  invisible(TRUE)
}
