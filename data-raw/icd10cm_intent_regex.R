icd10cm_intent_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  mutate(intent = clean_mech_names(intent)) %>%
  group_by(intent) %>%
  summarise(across(icd10cm_regex, make_regex), .groups = "drop")


icd10cm_intent_regex <- icd10cm_intent_regex %>%
  mutate(intent_mechanism = intent)

usethis::use_data(icd10cm_intent_regex, compress = "xz", overwrite = T)
