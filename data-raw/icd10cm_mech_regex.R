icd10cm_mech_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  group_by(mechanism) %>%
  summarise_at(vars(icd10cm_regex), icd_make_regex) %>%
  ungroup

icd10cm_mech_regex <- icd10cm_mech_regex %>%
  mutate(intent_mechanism = icd_clean_mech_names(mechanism))


usethis::use_data(icd10cm_mech_regex, compress = "xz", overwrite = T)
