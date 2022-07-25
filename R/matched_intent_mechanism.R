# matrix_matched_intent_mechanism ---------------------------------------------------------

#' Add matched intent and mechanism combined fields for injury ICD-10-CM.
#'
#' , reference
#' @param data input data
#' @param inj_col ecode and diagnosis column indices

#'
#' @return return the input with additional variables (92 intent_mechanism combinations)
#'
#' @export
#' @importFrom fuzzyjoin regex_left_join
#'
#' @examples
#' library(tidyverse)
#' library(fuzzyjoin)
#' dat <- data.frame(
#'   d1 = c("T63023", "X92821", "X99100", "T360x"),
#'   d2 = c("T65823", "Y030x0", "T17200", "V0100x")
#' )
#'
#' dat %>% matrix_matched_intent_mechanism(inj_col = c(1, 2))
#'
matrix_matched_intent_mechanism <- function(data, inj_col) {

  requireNamespace("dplyr", quietly = T)
  requireNamespace("tibble", quietly = T)
  requireNamespace("tidyr", quietly = T)
  requireNamespace("fuzzyjoin", quietly = T)

  data_names_ <- names(data)

  added_names_ <- icd10cm_intent_mech_regex$intent_mechanism

  col_to_add_ <- rep(NA_character_, length(added_names_)) %>%
    set_names(added_names_)

  dat2 <- data %>%
    tibble::add_column(u.id. = c(1:nrow(.)))

  dat3 <- dat2 %>%
    select(u.id., all_of(inj_col)) %>%
    pivot_longer(cols = -c(u.id.), names_to = "diag", values_to = "icd10cm") %>%
    fuzzyjoin::regex_left_join(icd10cm_intent_mech_regex %>%
                                 select(icd10cm_regex, intent_mechanism),
                               by = c(icd10cm = "icd10cm_regex")) %>%
    filter(!is.na(intent_mechanism)) %>%
    select(-c(diag, icd10cm, icd10cm_regex)) %>%
    distinct() %>%
    dplyr::mutate(case = 1)

  dat4 <- dat3 %>%
    pivot_wider(id_cols = u.id., names_from = intent_mechanism,
                values_from = case) %>%
    add_column(!!!col_to_add_[!names(col_to_add_) %in% names(.)])

  dat2 %>%
    left_join(dat4, by = "u.id.") %>%
    dplyr::mutate(across(all_of(added_names_), replace_na, replace = "0")) %>%
    select(all_of(data_names_), all_of(added_names_))

}


# matrix_matched_intent ---------------------------------------------------------

#' Add matched intent fields for injury ICD-10-CM.
#'
#' , reference
#' @param data input data
#' @param inj_col ecode and diagnosis column indices

#'
#' @return return the input with additional variables (5 intents)
#'
#' @export
#' @importFrom fuzzyjoin regex_left_join
#'
#' @examples
#' library(tidyverse)
#' library(fuzzyjoin)
#' dat <- data.frame(
#'   d1 = c("T63023", "X92821", "X99100", "T360x"),
#'   d2 = c("T65823", "Y030x0", "T17200", "V0100x")
#' )
#'
#' dat %>% matrix_matched_intent(inj_col = c(1, 2))
#'
matrix_matched_intent <- function(data, inj_col) {

  requireNamespace("dplyr", quietly = T)
  requireNamespace("tidyr", quietly = T)
  requireNamespace("tibble", quietly = T)
  requireNamespace("fuzzyjoin", quietly = T)

  data_names_ <- names(data)

  added_names_ <- icd10cm_intent_regex$intent_mechanism

  col_to_add_ <- rep(NA_character_, length(added_names_)) %>%
    set_names(added_names_)

  dat2 <- data %>%
    tibble::add_column(u.id. = c(1:nrow(.)))

  dat3 <- dat2 %>%
    select(u.id., all_of(inj_col)) %>%
    pivot_longer(cols = -c(u.id.), names_to = "diag", values_to = "icd10cm") %>%
    fuzzyjoin::regex_left_join(icd10cm_intent_regex  %>%
                                 select(icd10cm_regex, intent_mechanism),
                               by = c(icd10cm = "icd10cm_regex")) %>%
    filter(!is.na(intent_mechanism)) %>%
    select(-c(diag, icd10cm, icd10cm_regex)) %>%
    distinct() %>%
    dplyr::mutate(case = 1)

  dat4 <- dat3 %>%
    pivot_wider(id_cols = u.id., names_from = intent_mechanism,
                values_from = case) %>%
    add_column(!!!col_to_add_[!names(col_to_add_) %in% names(.)])

  dat2 %>%
    left_join(dat4, by = "u.id.") %>%
    dplyr::mutate(across(all_of(added_names_), replace_na, replace = 0)) %>%
    select(all_of(data_names_), all_of(added_names_))

}

# matrix_matched_mechanism ---------------------------------------------------------

#' Add matched mechanism fields for injury ICD-10-CM.
#'
#' , reference
#' @param data input data
#' @param inj_col ecode and diagnosis column indices

#'
#' @return return the input with additional variables (32 mechanisms)
#'
#' @export
#' @importFrom fuzzyjoin regex_left_join
#'
#' @examples
#' library(tidyverse)
#' library(fuzzyjoin)
#' dat <- data.frame(
#'   d1 = c("T63023", "X92821", "X99100", "T360x"),
#'   d2 = c("T65823", "Y030x0", "T17200", "V0100x")
#' )
#'
#' dat %>% matrix_matched_mechanism(inj_col = c(1, 2))
#'
matrix_matched_mechanism <- function(data, inj_col) {

  requireNamespace("dplyr", quietly = T)
  requireNamespace("tidyr", quietly = T)
  requireNamespace("fuzzyjoin", quietly = T)

  data_names_ <- names(data)

  added_names_ <- icd10cm_mech_regex$intent_mechanism

  col_to_add_ <- rep(NA_character_, length(added_names_)) %>%
    set_names(added_names_)

  dat2 <- data %>%
    tibble::add_column(u.id. = c(1:nrow(.)))

  dat3 <- dat2 %>%
    select(u.id., all_of(inj_col)) %>%
    pivot_longer(cols = -c(u.id.), names_to = "diag", values_to = "icd10cm") %>%
    fuzzyjoin::regex_left_join(icd10cm_mech_regex %>%
                                 select(icd10cm_regex, intent_mechanism),
                               by = c(icd10cm = "icd10cm_regex")) %>%
    filter(!is.na(intent_mechanism)) %>%
    select(-c(diag, icd10cm, icd10cm_regex)) %>%
    distinct() %>%
    dplyr::mutate(case = 1)

  dat4 <- dat3 %>%
    pivot_wider(id_cols = u.id., names_from = intent_mechanism,
                values_from = case) %>%
    add_column(!!!col_to_add_[!names(col_to_add_) %in% names(.)])

  dat2 %>%
    left_join(dat4, by = "u.id.") %>%
    dplyr::mutate(across(all_of(added_names_), replace_na, replace = 0)) %>%
    select(all_of(data_names_), all_of(added_names_))
}
