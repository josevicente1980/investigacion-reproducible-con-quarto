paquetes_necesarios <- c("dplyr", "readr", "here", "janitor", "tidyr")
faltantes <- paquetes_necesarios[
  !vapply(paquetes_necesarios, requireNamespace, logical(1), quietly = TRUE)
]
if (length(faltantes) > 0) stop("Faltan paquetes: ", paste(faltantes, collapse = ", "))

ruta_entrada <- here::here("datos", "original", "wdi_ecuador_2000_2024.csv")
if (!file.exists(ruta_entrada)) {
  stop("No existe el archivo original. Ejecute source('R/01_descargar_datos.R').")
}

dir.create(here::here("datos", "procesado"), recursive = TRUE, showWarnings = FALSE)

datos_ecuador <- readr::read_csv(ruta_entrada, show_col_types = FALSE) |>
  janitor::clean_names() |>
  dplyr::transmute(
    anio = year,
    crecimiento_pib,
    desempleo,
    inflacion,
    pib_per_capita_usd
  ) |>
  dplyr::arrange(anio) |>
  dplyr::mutate(
    periodo = dplyr::case_when(
      anio <= 2009 ~ "2000–2009",
      anio <= 2019 ~ "2010–2019",
      TRUE ~ "2020–2024"
    ),
    periodo = factor(periodo, levels = c("2000–2009", "2010–2019", "2020–2024"))
  )

control_calidad <- datos_ecuador |>
  dplyr::summarise(
    observaciones = dplyr::n(),
    anio_inicial = min(anio),
    anio_final = max(anio),
    faltantes_totales = sum(is.na(dplyr::across(where(is.numeric))))
  )

readr::write_csv(datos_ecuador, here::here("datos", "procesado", "ecuador_macro.csv"))
readr::write_csv(control_calidad, here::here("datos", "procesado", "control_calidad.csv"))

stopifnot(!anyDuplicated(datos_ecuador$anio), nrow(datos_ecuador) >= 20)
message("Verificación superada: base procesada con ", nrow(datos_ecuador), " años únicos.")
message("Siguiente paso: source('R/03_analizar_datos.R')")
