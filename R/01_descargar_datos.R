paquetes_necesarios <- c("WDI", "dplyr", "readr", "here", "tibble")
faltantes <- paquetes_necesarios[
  !vapply(paquetes_necesarios, requireNamespace, logical(1), quietly = TRUE)
]

if (length(faltantes) > 0) {
  stop(
    "Faltan paquetes: ", paste(faltantes, collapse = ", "),
    ". Ejecute primero source('R/00_instalar_paquetes.R')."
  )
}

indicadores <- c(
  crecimiento_pib = "NY.GDP.MKTP.KD.ZG",
  desempleo = "SL.UEM.TOTL.ZS",
  inflacion = "FP.CPI.TOTL.ZG",
  pib_per_capita_usd = "NY.GDP.PCAP.CD"
)

dir.create(here::here("datos", "original"), recursive = TRUE, showWarnings = FALSE)

datos_originales <- WDI::WDI(
  country = "ECU",
  indicator = indicadores,
  start = 2000,
  end = 2024,
  extra = FALSE
) |>
  dplyr::arrange(year)

diccionario <- tibble::tibble(
  variable = names(indicadores),
  codigo_banco_mundial = unname(indicadores),
  descripcion = c(
    "Crecimiento anual del PIB (%)",
    "Desempleo total (% de la fuerza laboral, estimación modelada OIT)",
    "Inflación, precios al consumidor (% anual)",
    "PIB per cápita (USD corrientes)"
  ),
  fuente = "World Development Indicators, Banco Mundial",
  fecha_descarga = as.character(Sys.Date())
)

readr::write_csv(
  datos_originales,
  here::here("datos", "original", "wdi_ecuador_2000_2024.csv")
)
readr::write_csv(
  diccionario,
  here::here("datos", "original", "diccionario_wdi.csv")
)

stopifnot(nrow(datos_originales) > 0, all(c("iso2c", "country", "year") %in% names(datos_originales)))
message("Verificación superada: se descargaron ", nrow(datos_originales), " observaciones.")
message("Siguiente paso: source('R/02_preparar_datos.R')")
