# Genera un dataset de ejemplo (ejemplo_convqc.rda)
if (!requireNamespace("usethis", quietly = TRUE)) install.packages("usethis")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")
if (!requireNamespace("lubridate", quietly = TRUE)) install.packages("lubridate")

set.seed(123)
fechas <- seq(lubridate::dmy("01/01/2020"), lubridate::dmy("31/01/2020"), by = "day")
val <- round(abs(rnorm(length(fechas), 20, 10)), 1)
fechas[5] <- fechas[4]   # duplicado a propósito
val[10] <- NA            # NA a propósito

ejemplo_convqc <- tibble::tibble(
  fecha = format(fechas, "%d/%m/%Y"),
  valor = val
)

usethis::use_data(ejemplo_convqc, overwrite = TRUE)
