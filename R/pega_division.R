#' pega_division
#'
#' Le pega a un dataframe que contenga una variable referente al ciiu a cuatro dígitos 
#' (cualquiera sea su nombre), la división correspondiente y su descripción.
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
#' pega_division("ciiu")
#' 

pega_division <- function(df, variable) {
  
  df %>% 
    dplyr::left_join(codiguera_ciiu %>% dplyr:: distinct(clase, division, desc_division),
              by = stats::setNames("clase", variable))
  
}
