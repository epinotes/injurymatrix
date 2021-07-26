

icd10cm_intent_mech_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  mutate(intent = clean_mech_names(intent),
         mechanism = clean_mech_names(mechanism)) %>%
  group_by(intent, mechanism) %>%
  summarise(across(icd10cm_regex, make_regex), .groups = "drop")


icd10cm_intent_mech_regex <- icd10cm_intent_mech_regex %>%
  mutate(intent_mechanism = clean_mech_names(paste(intent, mechanism, sep = "_")))


usethis::use_data(icd10cm_intent_mech_regex, compress = "xz", overwrite = T)
