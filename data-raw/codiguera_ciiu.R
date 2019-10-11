# Cargar base del ciiu a 5 dígitos, codiguera adaptada a Uruguay por el INE
cargar_ciiu_INE <- file.path('data-raw', 'EnricoCiiu.xlsx') %>%
  read_excel(col_names = TRUE) %>%
  rename_all(tolower) %>%
  rename(seccion = sección, descripcion = descripción) %>%
  filter(descripcion != "Otras actividades del servicio de alimentación") %>%
  mutate(ciiu_4 = if_else(ciiu_4 == 1010, 10100,                                       # Código incorrecto
                                if_else(ciiu_4 == 1919, 1619,                          # Corrección confirmada por INE
                                if_else(ciiu_4 == 7700, 77000,                         # Falta cero, mal reportada
                                if_else(ciiu_4 == 74300, 84300,                        # Código incorrecto
                                                  ciiu_4))))) %>%
  filter(seccion != "V", ciiu_4 != 68100) %>%
  add_row(seccion = c("B", "I", rep("L", 3)),
          ciiu_4 = c(07100, 56290, 68100, 68101, 68109),
          descripcion = c("Extracción de minerales de hierro",
                          "Otras actividades del servicio de alimentación",
                          "Actividades inmobiliarias con bienes propios o arrendados",
                          "Propiedad y explotación de bienes inmobiliarios propios no rurales",
                          "Otras actividades con bienes propios o arrendados")) %>%
  mutate(ciiu = str_pad(ciiu_4, 5, "left", "0"))

correcciones_ciiu <- file.path('data-raw', 'correcciones_ciiu.xlsx') %>%
  read_excel(col_names = TRUE) %>%
  janitor::clean_names() %>%
  transmute(ciiu = ciiu_4, descripcion) %>%
  mutate(ciiu = str_pad(ciiu, 5, "left", "0"),
         ciiu_4 = as.numeric(ciiu)) %>%
  left_join(cargar_ciiu_INE %>% select(- descripcion, - ciiu_4), by = "ciiu") %>%
  mutate(seccion = case_when(ciiu_4 == "0320" ~ "A", TRUE ~ seccion))

cargar_ciiu_INE <- cargar_ciiu_INE %>%
  filter(!ciiu %in% correcciones_ciiu$ciiu) %>%
  full_join(correcciones_ciiu)

cargar_ciiu_INE_anexo <- file.path('data-raw', 'EnricoCiiu.xlsx') %>%
  read_excel(col_names = TRUE) %>% rename_all(tolower) %>%
  rename(seccion = sección, descripcion = descripción) %>%
  filter(seccion == "V", as.numeric(ciiu_4) > 1900) %>%
  mutate(
    desc_seccion = "Anexo al manual de Clasificación Industrial Internacional Uniforme, (rev.4)",
    
    division = "01*",
    desc_division = "Anexo - Predios rurales",
    
    grupo = "019",
    desc_grupo = desc_division,
    
    clase = str_c(grupo, "0"),
    desc_clase = desc_grupo,
    
    subclase = str_pad(ciiu_4, 5, "left", "0"),
    desc_subclase = if_else(subclase %in% c("01901", "01902", "01905", "01908"),
                            str_c("Sin actividad económica", ' - ', descripcion),
                            str_c("Con actividad económica", ' - ', descripcion))) %>%
  select(- ciiu_4, - descripcion)

cargar_ciiu_division <- file.path('data-raw', 'ciiu_rev4_division.csv') %>%
  read_csv(locale = locale(encoding = "latin1")) %>%
  transmute(division = str_pad(division, 2, "left", "0"), desc_division)

cargar_ciiu_seccion <-  file.path('data-raw', 'ciiu_rev4_division.csv') %>%
  read_csv(locale = locale(encoding = "latin1")) %>%
  transmute(seccion, desc_seccion) %>%
  unique

cargar_seccion_division <- file.path('data-raw', 'ciiu_rev4_division.csv') %>%
  read_csv(locale = locale(encoding = "latin1")) %>%
  mutate(division = str_pad(division, 2, "left", "0")) %>%
  select(- industria_ad_hoc)

# Considerar el ciiu a 4 dígitos
codiguera_ciiu_4digitos <- function(df) {
  cargar_ciiu_INE %>% 
    transmute(ciiu = str_sub(ciiu, 1, 4), descripcion)
}

# Considerar el ciiu a 5 dígitos
codiguera_ciiu_5digitos <- function(df) {
  cargar_ciiu_INE %>% 
    transmute(ciiu, descripcion)
}

# Análisis codiguera del INE
ciiu <- cargar_ciiu_INE %>%
  arrange(ciiu) %>%
  mutate(division = ifelse(str_detect(ciiu, '000$') == TRUE, str_sub(ciiu, 1, 2), NA),             #  división detectada
         
         grupo = ifelse((is.na(division) == TRUE & str_detect(ciiu, '00$') == TRUE),               #  grupo detectado
                        str_sub(ciiu, 1, 3), NA),
         descripcion_grupo = ifelse(is.na(grupo) != TRUE, descripcion, NA),
         grupo = if_else(is.na(grupo) == TRUE, str_c(division, "0"), grupo),
         
         clase = ifelse((is.na(division) == TRUE & is.na(grupo) == TRUE &
                           str_detect(ciiu, '0$') == TRUE), str_sub(ciiu, 1, 4), NA),              #  clase detectada
         descripcion_clase = ifelse(is.na(clase) != TRUE, descripcion, NA),
         
         subclase = ifelse((is.na(division) == TRUE & is.na(grupo) == TRUE &                       #  subclase detectada
                              is.na(clase) == TRUE), ciiu, NA),
         descripcion_subclase = ifelse(is.na(subclase) != TRUE, descripcion, NA)) %>%
  
  mutate(clase = if_else((is.na(subclase) != TRUE & is.na(clase) == TRUE),
                         str_sub(subclase, 1, 4), clase),
         grupo = if_else((is.na(clase) != TRUE & is.na(grupo) == TRUE),
                         str_sub(clase, 1, 3), grupo),
         division = if_else((is.na(grupo) != TRUE & is.na(division) == TRUE),
                            str_sub(grupo, 1, 2), division)) %>%
  
  mutate(subclase = if_else(clase == "4631", "46310", subclase),
         descripcion_subclase = if_else(clase == "4631",
                                        "Comercio al por mayor de aves y sus productos",
                                        descripcion_subclase))

#### Componentes de la codiguera completa

seccion <- cargar_ciiu_seccion                                                                     #  21 secciones, falta unicamente la sección V

division <- cargar_ciiu_division                                                                   #  88 divisiones, está completa.

seccion_division <- cargar_seccion_division %>%
  select(seccion, division) %>%
  unique

grupo <- ciiu %>% 
  select(division, grupo, descripcion_grupo) %>%
  add_row(division = c("01", "03", "07", "10"),
          grupo = c("011", "032", "071", "101"),
          descripcion_grupo = c("Cultivo de productos no perennes",                                #  agrega grupos faltantes
                                "Acuicultura",                                                     #  según archivo "CIIU-Rev-4_Notas-explicativas.pdf"
                                "Extracción de minerales de hierro",
                                "Procesamiento y conservación de carne")) %>%
  left_join(division %>% filter(division %in% c("11", "12", "17", "21", "31", "36",                #  asigna descripcion de la división a los grupos que corresponde
                                                "37", "39", "41", "61", "62", "75",                #  según archivo "CIIU-Rev-4_Notas-explicativas.pdf"
                                                "90", "91", "92", "96", "97", "99")),
            by = "division") %>%
  mutate(desc_grupo = if_else(is.na(descripcion_grupo) == TRUE, desc_division,
                              if_else(grupo == "651", "Seguros", descripcion_grupo))) %>%
  select(grupo, desc_grupo) %>%
  filter(is.na(desc_grupo) != TRUE) %>%
  unique %>%
  arrange(grupo)

clase <- ciiu %>% 
  select(grupo, clase, descripcion_clase, subclase) %>%
  left_join(grupo %>%
              filter(grupo %in% c("120", "210", "360", "370", "390", "410", "461",                 #  asigna descripcion de la grupos a las clases que corresponde
                                  "462", "463", "750", "900", "920", "970", "990")),               #  según archivo "CIIU-Rev-4_Notas-explicativas.pdf"
            by = "grupo") %>%
  mutate(clase = if_else(is.na(desc_grupo) != TRUE, str_c(grupo, "0"), clase)) %>%
  mutate(desc_clase = if_else(is.na(descripcion_clase) == TRUE,
                              desc_grupo, descripcion_clase)) %>%
  select(clase, desc_clase) %>%
  mutate(clase =                                                                                   # 46310 corresponde a la décima clase del grupo 463
           if_else(desc_clase == "Comercio al por mayor de aves y sus productos",
                   "4631", clase)) %>%
  filter(is.na(desc_clase) != TRUE) %>% unique %>% arrange(clase)

subclase <- ciiu %>%
  select(clase, subclase, descripcion_subclase) %>%
  left_join(clase %>%
              filter(clase %in% c("1200", "2100", "3600", "3700", "3900",                          #  asigna descripcion de la clase a las subclases que corresponde
                                  "4100", "7500", "9000", "9900")),                                #  según archivo "CIIU-Rev-4_Notas-explicativas.pdf"
            by = "clase") %>%
  mutate(subclase =
           if_else(is.na(desc_clase) != TRUE, str_c(clase, "0"), subclase)) %>%
  mutate(desc_subclase =
           if_else(is.na(descripcion_subclase) == TRUE, desc_clase, descripcion_subclase)) %>%
  select(subclase, desc_subclase) %>%
  filter(is.na(desc_subclase) != TRUE) %>%
  unique %>%
  arrange(subclase)

codiguera_ciiu <- seccion %>%
    left_join(seccion_division, by = "seccion") %>%
    left_join(division, by = "division") %>%
    left_join(grupo %>% mutate(division = str_sub(grupo, 1, 2)), by = "division") %>%
    left_join(clase %>% mutate(grupo = str_sub(clase, 1, 3)), by = "grupo") %>%                              # ciiu a 4 dígitos
    mutate(clase = case_when(is.na(clase) == TRUE ~ str_c(grupo, 0), TRUE ~ clase),
                  desc_clase = case_when(is.na(desc_clase) == TRUE ~ desc_grupo, TRUE ~ desc_clase)) %>%
    left_join(subclase %>% mutate(clase = str_sub(subclase, 1, 4),                                           # ciiu a 5 dígitos
                                         grupo = str_sub(subclase, 1, 3)),
                     by = c("clase", "grupo")) %>%
    mutate(subclase = case_when(is.na(subclase) == TRUE ~ str_c(clase, 0), TRUE ~ subclase),
                  desc_subclase = case_when(is.na(desc_subclase) == TRUE ~ desc_clase, TRUE ~ desc_subclase)) %>%
    mutate(desc_clase = if_else(clase == "4631", "Comercio al por mayor de alimentos, bebidas y tabaco.",
                                       desc_clase)) %>%
    union_all(cargar_ciiu_INE_anexo) %>%
    unique

usethis::use_data(codiguera_ciiu, overwrite = TRUE)

division <- codiguera_ciiu %>%
    transmute(division, desc_division) %>%
    distinct()

usethis::use_data(division, overwrite = TRUE)

seccion <- codiguera_ciiu %>%
    dplyr::transmute(seccion, desc_seccion) %>%
    dplyr::distinct()

usethis::use_data(seccion, overwrite = TRUE)

grupo <- codiguera_ciiu %>%
    transmute(grupo, desc_grupo) %>%
    distinct()

usethis::use_data(grupo, overwrite = TRUE)

clase <- codiguera_ciiu %>%
    transmute(clase, desc_clase) %>%
    distinct()

usethis::use_data(clase, overwrite = TRUE)

subclase <- codiguera_ciiu %>%
    dplyr::transmute(subclase, desc_subclase) %>%
    dplyr::distinct()

usethis::use_data(subclase, overwrite = TRUE)
