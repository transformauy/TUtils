#' Codiguera CIIU 4.
#'
#' Codiguera de ramas de actividad según Clasificación Industrial Internacional Uniforme Rev.4 (CIIU), en 
#' base al archivo de referencia del INE "Estructura CIIU4.pdf".
#'
#' @format Un data frame con 695 filas y 10 variables:
#' \describe{
#'   \item{seccion}{Nivel de clasificación que agrupa la información estadística correspondiente a sectores económicos con características homogéneas. Su notación se realiza a través de códigos alfabéticos de un carácter.}
#'   \item{desc_seccion}{Descripción de la sección.}
#'   \item{division}{Corresponde a una categoría de tabulación más detallada, agrupa actividades pertenecientes a un mismo sector económico con mayor grado de homogeneidad, teniendo en cuenta la especialidad de las actividades económicas que desarrollan, las características y el uso de los bienes producidos y los servicios prestados, los insumos, el proceso y la tecnología de producción utilizada. Su notación corresponde a los dos primeros dígitos.}
#'   \item{desc_division}{Descripción de la división.}
#'   \item{grupo}{Clasifica las categorías de actividades organizadas en una división de manera más especializada y homogénea. Se denota por tres dígitos, de los cuales los dos primeros corresponden a la división; y el último, identifica al Grupo.}
#'   \item{desc_grupo}{Descripción del grupo.}
#'   \item{clase}{Categoría que clasifica características específicas de una actividad. Su notación corresponde a cuatro dígitos, de los cuales los dos primeros identifican la División; el tercero, el Grupo; y el último a la Clase.}
#'   \item{desc_clase}{Descripción clase.}
#'   \item{subclase}{Corresponde al nivel más desagregado en este clasificador. Su notación corresponde a cinco dígitos, de los cuales los dos primeros identifican la División; el tercero, el Grupo; el cuarto, la Clase; y el último, a la Subclase.}
#'   \item{desc_subclase}{Descripción subclase.}
#'   
#'   
#' }
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"codiguera_ciiu"

#' Sección CIIU 4.
#'
#' Codiguera de ramas de actividad según Clasificación Industrial Internacional Uniforme Rev.4 (CIIU), en 
#' base al archivo de referencia del INE "Estructura CIIU4.pdf".
#'
#' @format Un data frame con 22 filas y 2 variables:
#' \describe{
#'   \item{seccion}{Nivel de clasificación que agrupa la información estadística correspondiente a sectores económicos con características homogéneas. Su notación se realiza a través de códigos alfabéticos de un carácter.}
#'   \item{desc_seccion}{Descripción de la sección.}
#'   
#' }
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"seccion"

#' División CIIU 4.
#'
#' @format Un data frame con 89 filas y 2 variables:
#' \describe{
#'   \item{division}{Corresponde a una categoría de tabulación más detallada, agrupa actividades pertenecientes a un mismo sector económico con mayor grado de homogeneidad, teniendo en cuenta la especialidad de las actividades económicas que desarrollan, las características y el uso de los bienes producidos y los servicios prestados, los insumos, el proceso y la tecnología de producción utilizada. Su notación corresponde a los dos primeros dígitos.}
#'   \item{desc_division}{Descripción de la división.}
#'   
#' }
#' 
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"division"

#' Grupo CIIU 4.
#'
#' \describe{
#'   \item{grupo}{Clasifica las categorías de actividades organizadas en una división de manera más especializada y homogénea. Se denota por tres dígitos, de los cuales los dos primeros corresponden a la división; y el último, identifica al Grupo.}
#'   \item{desc_grupo}{Descripción del grupo.}
#'   
#' }
#' 
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"grupo"

#' Clase CIIU 4.
#'
#' \describe{
#'   \item{clase}{Categoría que clasifica características específicas de una actividad. Su notación corresponde a cuatro dígitos, de los cuales los dos primeros identifican la División; el tercero, el Grupo; y el último a la Clase.}
#'   \item{desc_clase}{Descripción clase.}
#'   
#' }
#' 
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"clase"

#' Subclase CIIU 4.
#'
#' \describe{
#'   \item{subclase}{Corresponde al nivel más desagregado en este clasificador. Su notación corresponde a cinco dígitos, de los cuales los dos primeros identifican la División; el tercero, el Grupo; el cuarto, la Clase; y el último, a la Subclase.}
#'   \item{desc_subclase}{Descripción subclase.}
#'   
#' }
#' 
#' @source \url{https://www.dgi.gub.uy/wdgi/afiledownload?2,4,944,O,S,0,17330%3BS%3B6%3B108,}
"subclase"
