# ConvQcENANDES

**ConvQcENANDES** es un paquete en R desarrollado por Bruce A. Tumbaco Vega dentro del proyecto ENANDES+.
Permite realizar controles de calidad convencionales en series de precipitación y temperatura, incluyendo verificación de formato, rango lógico, Z-score, Isolation Forest y PCA.

## Instalación
```r
install.packages("devtools")
devtools::install_github("Bruce1998a/ConvQcENANDES", build_vignettes = FALSE)
library(ConvQcENANDES)
```

## Ejemplo de uso
```r
library(ConvQcENANDES)
data("ejemplo_convqc")

d <- verificacion_formato(ejemplo_convqc, variable = 1, "01/01/2020", "31/01/2020")
d <- rango_logico(d, 0, 300, eliminar = FALSE)
d <- zscore_etiquetar(d, variable = 1, percentil = 0.99)
d <- isolation_forest_etiquetar(d, contaminacion = 0.01, n_arboles = 200)
d <- pca_outliers(d, n_comp = 2, percentil = 0.99)
d <- construir_validacion(d)

graficar_enandes(d, tipo = 3)
guardar_resultados(d, formato = "csv", nombre = "resultado_M0003")
```
