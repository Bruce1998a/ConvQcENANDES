# ConvQcENANDES

Paquete R para **control de calidad** de series convencionales (ENANDES+).  
Incluye: verificación de formato, rango lógico, **Z-score** y **Isolation Forest**.  
Carga datos de ejemplo con `datos_ejemplo_convqc()`.

## Instalación
```r
install.packages("devtools")
devtools::install_github("Bruce1998a/ConvQcENANDES", build_vignettes = FALSE)
library(ConvQcENANDES)
```

## Uso mínimo
```r
library(ConvQcENANDES)

df <- ejemplo_convqc()

d <- verificacion_formato(df, variable = 1, "01/01/2020", "31/01/2020")
d <- rango_logico(d, inferior = 0, superior = 300, eliminar = FALSE)
d <- zscore_etiquetar(d, variable = 1, percentil = 0.99)
d <- isolation_forest_etiquetar(d, contaminacion = 0.01, n_arboles = 200)
d <- construir_validacion(d)

graficar_enandes(d, tipo = 3)     # serie con atípicos Z-score
graficar_enandes(d, tipo = 4)     # serie con atípicos Isolation Forest

guardar_resultados(d, formato = "csv", nombre = "resultado_convqc")
```

## Ayuda
- `help(package = "ConvQcENANDES")` lista todas las funciones.
- `?verificacion_formato`, `?zscore_etiquetar`, `?isolation_forest_etiquetar`, etc.
