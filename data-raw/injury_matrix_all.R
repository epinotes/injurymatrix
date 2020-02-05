injury_matrix_all <- readr::read_rds("injury_matrix_all.rds")

usethis::use_data(injury_matrix_all, compress = "xz", overwrite = T)

