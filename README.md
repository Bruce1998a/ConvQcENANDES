# ConvQcENANDES

Conventional quality control (**ConvQC**) for daily climate series used in **ENANDES+**.

## ✨ Features
- Format check (date `dd/mm/yyyy`, numeric value) and coverage of `[start, end]`
- Logical ranges (user-specified bounds; optional removal)
- Z-score (modified for precipitation; standard for temperatures) with percentile threshold
- Isolation Forest (isotree) with configurable contamination and tree params
- PCA-based outliers (Mahalanobis distance on PC scores)
- Autoencoder outliers (H2O) via reconstruction error
- Plots (boxplot, time series, Z/ISO outliers, PCA scatter, AE error)
- Export to CSV/Excel/TXT
- Final boolean column `validacion`

## 📦 Install
```r
install.packages("devtools")
devtools::install_github("Bruce1998a/ConvQcENANDES")
library(ConvQcENANDES)
```

## 📘 Input format
- `fecha` in **"dd/mm/yyyy"**
- `valor` numeric
- `variable`:
  - 1 = Precipitación (mm)
  - 2 = Temperatura media (°C)
  - 3 = Temperatura máxima (°C)
  - 4 = Temperatura mínima (°C)

## 🚀 Minimal pipeline
```r
library(ConvQcENANDES)

# Example data (create your own data frame with fecha/valor)
df <- data.frame(
  fecha = format(seq(lubridate::dmy("01/01/2020"), lubridate::dmy("31/01/2020"), by="day"), "%d/%m/%Y"),
  valor = pmax(0, round(rnorm(31, 20, 10), 1))
)

d <- verificacion_formato(df, variable = 1, fecha_inicio = "01/01/2020", fecha_fin = "31/01/2020")
d <- rango_logico(d, inferior = 0, superior = 300, eliminar = FALSE)
d <- zscore_etiquetar(d, variable = 1, percentil = 0.99)
d <- isolation_forest_etiquetar(d, contaminacion = 0.01, n_arboles = 200, semilla = 42)
d <- pca_outliers(d, n_comp = 2, percentil = 0.99)
d <- autoencoder_h2o(d, hidden = c(8,3,8), epochs = 100, percentil = 0.99, semilla = 1234)
d <- construir_validacion(d)

p_box <- graficar_enandes(d, 1)
p_ts  <- graficar_enandes(d, 2)
p_z   <- graficar_enandes(d, 3)
p_iso <- graficar_enandes(d, 4)
p_pca <- graficar_enandes(d, 5)
p_ae  <- graficar_enandes(d, 6)

guardar_resultados(d, "convqc_resultados", "excel")
```

## 🧪 Build locally
```r
devtools::document()
devtools::build()
devtools::install()
```

## 📄 Citation
See `inst/CITATION`.
