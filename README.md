# Investigación reproducible con Quarto

Curso introductorio de tres clases de dos horas para aprender a desarrollar una investigación breve con **R, Quarto, Git y GitHub**. El caso conductor utiliza indicadores socioeconómicos de Ecuador obtenidos mediante código desde World Development Indicators.

## Productos del curso

- tres presentaciones RevealJS
- tres prácticas guiadas
- un informe reproducible en HTML y Word
- scripts numerados para descargar, preparar y analizar datos
- publicación automática mediante GitHub Pages

## Estructura

```text
R/                  Scripts ejecutables en orden
clases/             Presentaciones RevealJS
datos/original/     Descargas sin modificación manual
datos/procesado/    Datos reconstruibles
practicas/          Actividades de cada sesión
proyecto/           Informe final
referencias/        Bibliografía BibTeX
recursos/           Estilos del sitio y las diapositivas
resultados/         Figuras, tablas y modelos generados
```

## Requisitos

Instale [R](https://cran.r-project.org/), [RStudio Desktop](https://posit.co/download/rstudio-desktop/), [Quarto](https://quarto.org/docs/get-started/) y [Git](https://git-scm.com/downloads). También necesita una cuenta de GitHub.

## Uso desde cero

1. Clone el repositorio.

   ```powershell
   git clone https://github.com/josevicente1980/investigacion-reproducible-con-quarto.git
   cd investigacion-reproducible-con-quarto
   ```

2. Abra `investigacion-reproducible-con-quarto.Rproj`.

3. Ejecute en la consola de R, una línea por vez.

   ```r
   source("R/00_instalar_paquetes.R")
   source("R/01_descargar_datos.R")
   source("R/02_preparar_datos.R")
   source("R/03_analizar_datos.R")
   source("R/99_verificar_proyecto.R")
   ```

4. Renderice las clases.

   ```r
   source("R/98_renderizar_clases.R")
   ```

5. Para previsualizar todo el sitio, ejecute en la terminal de RStudio:

   ```powershell
   quarto preview
   ```

## Flujo cotidiano

```powershell
git pull
git status
# editar y renderizar
git diff
git add .
git commit -m "Describe con precisión el cambio"
git push
```

## Publicación

El flujo `.github/workflows/publicar.yml` reconstruye los datos, renderiza el sitio y lo publica con GitHub Pages. En **Settings > Pages**, seleccione **GitHub Actions** como fuente.

Sitio esperado: <https://josevicente1980.github.io/investigacion-reproducible-con-quarto/>

## Fuentes principales

- [Documentación oficial de Quarto](https://quarto.org/docs/)
- [Presentaciones RevealJS en Quarto](https://quarto.org/docs/presentations/revealjs/)
- [Publicación de Quarto en GitHub Pages](https://quarto.org/docs/publishing/github-pages.html)
- [World Development Indicators](https://databank.worldbank.org/source/world-development-indicators)

## Licencia

El código se distribuye bajo licencia MIT. Los materiales docentes pueden reutilizarse con atribución al autor.
