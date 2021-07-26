icd10cm_mech_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  mutate(mechanism = clean_mech_names(mechanism)) %>%
  group_by(mechanism) %>%
  summarise(across(icd10cm_regex, make_regex), .groups = "drop")

icd10cm_mech_regex <- icd10cm_mech_regex %>%
  mutate(intent_mechanism = mechanism)


usethis::use_data(icd10cm_mech_regex, compress = "xz", overwrite = T)
