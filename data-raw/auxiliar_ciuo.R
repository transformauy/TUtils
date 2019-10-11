
# Librerías
library(readxl)
library(dplyr)


# archivo recibido en mail 26/06/2018, asunto: consulta
codiguera_ciuo <- file.path('data-raw', 'listado_a_usar_Ocupaciones.xls') %>%
  read_excel(skip = 2, 
             col_names = c("denominacion_ocupaciones", "cnuo_95", "descripcion", "ciuo")) %>% 
  transmute(ciuo, descripcion) %>%
  mutate(descripcion = case_when(ciuo == "1412" ~ "Gerentes de restaurantes",
                                 ciuo == "1431" ~ "Gerentes de centros deportivos, de esparcimiento y culturales",
                                 TRUE ~ descripcion)) %>%
  distinct()
# save(codiguera_ciuo, file = 'data/codiguera_ciuo.rda')
