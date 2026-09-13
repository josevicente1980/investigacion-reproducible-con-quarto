paquetes_necesarios <- c("broom", "dplyr", "ggplot2", "here", "readr", "scales", "tidyr")
faltantes <- paquetes_necesarios[
  !vapply(paquetes_necesarios, requireNamespace, logical(1), quietly = TRUE)
]
if (length(faltantes) > 0) stop("Faltan paquetes: ", paste(faltantes, collapse = ", "))

ruta_datos <- here::here("datos", "procesado", "ecuador_macro.csv")
if (!file.exists(ruta_datos)) {
  stop("No existe la base procesada. Ejecute source('R/02_preparar_datos.R').")
}

dir.create(here::here("resultados", "figuras"), recursive = TRUE, showWarnings = FALSE)
dir.create(here::here("resultados", "tablas"), recursive = TRUE, showWarnings = FALSE)
dir.create(here::here("resultados", "modelos"), recursive = TRUE, showWarnings = FALSE)

datos_ecuador <- readr::read_csv(ruta_datos, show_col_types = FALSE)

resumen_periodo <- datos_ecuador |>
  dplyr::group_by(periodo) |>
  dplyr::summarise(
    crecimiento_promedio = mean(crecimiento_pib, na.rm = TRUE),
    desempleo_promedio = mean(desempleo, na.rm = TRUE),
    inflacion_promedio = mean(inflacion, na.rm = TRUE),
    .groups = "drop"
  )

modelo_exploratorio <- stats::lm(
  desempleo ~ crecimiento_pib + inflacion,
  data = datos_ecuador
)

figura_series <- datos_ecuador |>
  dplyr::select(anio, crecimiento_pib, desempleo, inflacion) |>
  tidyr::pivot_longer(-anio, names_to = "indicador", values_to = "valor") |>
  ggplot2::ggplot(ggplot2::aes(anio, valor, color = indicador)) +
  ggplot2::geom_hline(yintercept = 0, color = "grey75", linewidth = 0.4) +
  ggplot2::geom_line(linewidth = 0.9, na.rm = TRUE) +
  ggplot2::facet_wrap(~indicador, scales = "free_y", ncol = 1) +
  ggplot2::scale_color_manual(values = c("#123B5D", "#007F7B", "#8B2F4A")) +
  ggplot2::labs(x = NULL, y = "%", color = NULL) +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(legend.position = "none", panel.grid.minor = ggplot2::element_blank())

readr::write_csv(resumen_periodo, here::here("resultados", "tablas", "resumen_periodo.csv"))
readr::write_csv(
  broom::tidy(modelo_exploratorio, conf.int = TRUE),
  here::here("resultados", "modelos", "modelo_desempleo.csv")
)
ggplot2::ggsave(
  here::here("resultados", "figuras", "series_ecuador.png"),
  figura_series,
  width = 8,
  height = 8,
  dpi = 160
)

stopifnot(
  file.exists(here::here("resultados", "tablas", "resumen_periodo.csv")),
  file.exists(here::here("resultados", "figuras", "series_ecuador.png"))
)
message("Verificación superada: tablas, modelo y figura fueron generados.")
message("Siguiente paso: quarto render")
