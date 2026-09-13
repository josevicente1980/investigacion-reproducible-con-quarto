archivos <- c(
  "clases/clase_1/01_fundamentos.qmd",
  "clases/clase_2/02_datos_evidencia.qmd",
  "clases/clase_3/03_publicacion.qmd"
)

if (!nzchar(Sys.which("quarto"))) {
  stop("Quarto no está disponible en PATH. Abra el proyecto en RStudio o instale Quarto.")
}

for (archivo in archivos) {
  message("Renderizando: ", archivo)
  estado <- system2("quarto", c("render", shQuote(archivo)))
  if (!identical(estado, 0L)) stop("Falló el render de ", archivo)
}

message("Verificación superada: las tres clases se renderizaron correctamente.")
