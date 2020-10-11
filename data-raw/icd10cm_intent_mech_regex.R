

icd10cm_intent_mech_regex <- readr::read_rds("injury_matrix_all.rds") %>%
  group_by(intent, mechanism) %>%
  summarise_at(vars(icd10cm_regex), icd_make_regex) %>%
  ungroup

icd10cm_intent_mech_regex <- icd10cm_intent_mech_regex %>%
  mutate(mechanism = icd_clean_mech_names(mechanism))

icd10cm_intent_mech_regex <- icd10cm_intent_mech_regex %>%
  mutate(intent_mechanism = paste(intent, mechanism, sep = "_"))


usethis::use_data(icd10cm_intent_mech_regex, compress = "xz", overwrite = T)
