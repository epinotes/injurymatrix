icd10cm_mech_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  mutate(mechanism = icd_clean_mech_names(mechanism)) %>%
  group_by(mechanism) %>%
  summarise(across(icd10cm_regex, icd_make_regex), .groups = "drop")

icd10cm_mech_regex <- icd10cm_mech_regex %>%
  mutate(intent_mechanism = mechanism)


usethis::use_data(icd10cm_mech_regex, compress = "xz", overwrite = T)
