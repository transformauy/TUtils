#' pega_grupo
#'
#' Le pega a un dataframe que contenga una variable referente al ciiu a cuatro dígitos 
#' (cualquiera sea su nombre), el grupo correspondiente y su descripción.
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
#' pega_grupo("ciiu")
#' 

pega_grupo <- function(df, variable) {
  
  df %>% 
    left_join(codiguera_ciiu %>% distinct(clase, grupo, desc_grupo),
              by = setNames("clase", variable))
  
}

