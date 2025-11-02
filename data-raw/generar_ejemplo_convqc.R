# Script para generar el dataset de ejemplo
ejemplo_convqc <- read.csv("data-raw/ejemplo_convqc.csv")
usethis::use_data(ejemplo_convqc, overwrite = TRUE)
