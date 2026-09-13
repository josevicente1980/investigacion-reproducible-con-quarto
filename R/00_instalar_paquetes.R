paquetes <- c(
  "broom", "dplyr", "ggplot2", "gt", "here", "janitor", "knitr",
  "readr", "rmarkdown", "scales", "tidyr", "WDI"
)

faltantes <- paquetes[!vapply(paquetes, requireNamespace, logical(1), quietly = TRUE)]

if (length(faltantes) > 0) {
  install.packages(faltantes, repos = "https://cloud.r-project.org")
} else {
  message("Verificación superada: todos los paquetes ya están instalados.")
}

message("Siguiente paso: source('R/01_descargar_datos.R')")
