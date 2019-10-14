#' pega_seccion
#'
#' Le pega a un dataframe que contenga una variable referente al ciiu a cuatro dígitos 
#' (cualquiera sea su nombre), la sección correspondiente y su descripción.
#'
#' @param df 
#' @param variable 
#'
#' @return
#' @export
#'
#' @examples
#' 
#' prueba <- clase %>% 
#' rename(ciiu = clase) %>% 
#' pega_seccion("ciiu")
#' 

pega_seccion <- function(df, variable) {
  
  df %>% 
    left_join(codiguera_ciiu %>% distinct(clase, seccion, desc_seccion),
              by = setNames("clase", variable))
  
}


