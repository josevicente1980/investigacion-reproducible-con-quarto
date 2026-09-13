archivos_obligatorios <- c(
  "_quarto.yml", "README.md", "index.qmd", "programa.qmd",
  "clases/clase_1/01_fundamentos.qmd",
  "clases/clase_2/02_datos_evidencia.qmd",
  "clases/clase_3/03_publicacion.qmd",
  "practicas/practica_1.qmd", "practicas/practica_2.qmd", "practicas/practica_3.qmd",
  "proyecto/reporte.qmd",
  "R/01_descargar_datos.R", "R/02_preparar_datos.R", "R/03_analizar_datos.R"
)

faltantes <- archivos_obligatorios[!file.exists(archivos_obligatorios)]
if (length(faltantes) > 0) stop("Faltan archivos: ", paste(faltantes, collapse = ", "))

qmd <- list.files(recursive = TRUE, pattern = "[.]qmd$", full.names = TRUE)
sin_yaml <- qmd[!vapply(qmd, function(x) identical(readLines(x, n = 1), "---"), logical(1))]
if (length(sin_yaml) > 0) stop("Archivos sin cabecera YAML: ", paste(sin_yaml, collapse = ", "))

message("Verificación superada: estructura completa y ", length(qmd), " archivos QMD con YAML.")
