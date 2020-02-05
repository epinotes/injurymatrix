icd10cm_intent_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  group_by(intent) %>%
  summarise_at(vars(icd10cm_regex), icd_make_regex) %>%
  ungroup


icd10cm_intent_regex <- icd10cm_intent_regex %>%
  mutate(intent_mechanism = intent)

usethis::use_data(icd10cm_intent_regex, compress = "xz", overwrite = T)
