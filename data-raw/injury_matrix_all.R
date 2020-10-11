
# library(readxl)
# library(tidyverse)
#

# download original matrices ----------------------------------------------


# url = "ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/injury/tools/2020 ICD-10-CM_Non-Poisoning_Cause_Matrix  ALL codes 100120.xlsx"

#download.file(url, destfile = "2020 ICD-10-CM_Non-Poisoning_Cause_Matrix  ALL codes 100120.xlsx")

#download.file(url, destfile = "22020 ICD-10-CM_Poisoning_Matrix ALL codes 100120.xlsx")


# Concatenate all the worksheets from the two matrix workbooks ------------



# path_np <- "2020 ICD-10-CM_Non-Poisoning_Cause_Matrix  ALL codes 100120.xlsx"
#
# sheets_np <- path_np %>%
#   excel_sheets() %>%
#   set_names()
#
#
# injury_matrix_np <- map_dfr(
#   sheets_np,
#   ~ read_excel(path_np, sheet = .x),
#   .id = "sheet"
# )
#
# injury_matrix_np <- injury_matrix_np %>%
#   filter(!is.na(ICD10CM)) %>%
#   mutate(type = "non_poisoning")
#
# path_p <- "2020 ICD-10-CM_Poisoning_Matrix ALL codes 100120.xlsx"
#
# sheets_p <- path_p %>%
#   excel_sheets() %>%
#   set_names()
#
# injury_matrix_p <- map_dfr(
#   sheets_p,
#   ~ read_excel(path_p, sheet = .x),
#   .id = "sheet"
# )
#
# injury_matrix_p <- injury_matrix_p %>%
#   filter(!is.na(ICD10CM)) %>%
#   mutate(type = "poisoning")
#
# injury_matrix_all_20 <- injury_matrix_np %>%
#   bind_rows(injury_matrix_p) %>%
#   select(intent = sheet,
#          mechanism = MECHANISM,
#          icd10cm = ICD10CM,
#          description = DESCRIPTION)
#
#
# injury_matrix_all_20 <- injury_matrix_all_20 %>%
#   mutate(icd10cm_regex = gsub("(?<!^)x", ".", icd10cm,
#                               ignore.case = T, perl = T))
#
# injury_matrix_all_20 <- injury_matrix_all_20 %>%
#   select(mechanism, icd10cm, description, intent, icd10cm_regex)
#
#
# injury_matrix_all_20 %>%
#   write_rds("injury_matrix_all.rds", compress = "xz")


# compress the final matrix for the package -------------------------------


injury_matrix_all <- readr::read_rds("injury_matrix_all.rds")

usethis::use_data(injury_matrix_all, compress = "xz", overwrite = T)

