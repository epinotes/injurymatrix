
# make the icd10cm regex

icd_make_regex <- purrr::compose(
  function(x) gsub("X", "^X", x),
  function(x) paste(x, collapse = "|"),
  function(x) gsub("(?<!^)x", ".", x, ignore.case = T, perl = T)
)

# cleaning the names for mechanism

icd_clean_mech_names <- purrr::compose(
  # remove repeat "_" and extreme "_"
  function(x) gsub("(_)(?=_*\\1)|^_|_$", "", x, perl = T),
  # not [A-Za-z0-9_] and replace with "_"
  function(x) gsub("\\W", "_", x),
  # parenthesis and its contents
  function(x) gsub("\\(.+\\)", "", x)
)

# finding matches in multiple fields

#' Create a new variable based on pattern in the argument expr
#'
#' @param data input data
#' @param expr regular expression describing the pattern of interest
#' @param colvec indices of variables of interest
#' @param ignore.case logical
#' @param perl logical
#'
#' @return new variable matching the pattern described in the regular expression
#' @export
#' @importFrom purrr flatten_dbl map_dfr
#'
#' @examples
#'
#' library(dplyr)
#' library(purrr)
#' icd10cm_data150 %>%
#'   mutate(hero = find_diag(., expr = "T401.[1-4]", colvec = c(2:6))) %>%
#'   count(hero)
find_diag <- function(data, expr, colvec, ignore.case = T, perl = T) {

  requireNamespace("dplyr", quietly = T)
  # assign '1' if the regular expression matched
  f1 <- function(x) grepl(expr, x, ignore.case = ignore.case, perl = perl)
  # any 1 in the diagnosis field suffices
  f2 <- function(x) {
    sign(rowSums(x, na.rm = TRUE))
  }

  data %>% as_tibble() %>%
    select({{colvec}}) %>%
    mutate_all(as.character) %>%
    purrr::map_dfr(f1) %>%
    transmute(new_diag = f2(.)) %>%
    flatten_dbl()
}


# a row operation that will form a vector of the first match of a pattern.

#' a row operation that will form a vector of the first match of a pattern.
#'
#'
#' @param data input data
#' @param colvec selected columns to match
#' @param pattern the pattern to match

#' @return return the vector of the matched characters with NA for a no match
#' @export
#' @importFrom purrr transpose detect map map_if
#' @examples
#' dat <- data.frame(x1 = letters[1:3], x2 = c("d", "a", "e"))
#' library(dplyr)
#' library(purrr)
#' dat %>% mutate(x3 = icd_first_valid_regex(., colvec = c(1:2), pattern = "a"))
#'
icd_first_valid_regex <- function(data, colvec, pattern) {

  requireNamespace("dplyr", quietly = T)
  requireNamespace("purrr", quietly = T)

  f0 <- function(x) grepl(pattern = pattern, x, ignore.case = T, perl = T)
  f1 <- function(x) detect(x, f0)
  data %>%
    select({{colvec}}) %>%
    map_dfr(as.character) %>%
    transpose() %>%
    map(f1) %>%
    map_if(is.null, ~NA_character_) %>%
    unlist()
}

# a row operation that will form an index vector of the first match of a pattern

icd_first_valid_index <- function(data, colvec, pattern) {

  requireNamespace("dplyr", quietly = T)
  requireNamespace("purrr", quietly = T)

  f0 <- function(x) grepl(pattern = pattern, x, ignore.case = T, perl = T)
  f1 <- function(x) purrr::detect_index(x, f0)
  data %>%
    select({{colvec}}) %>%
    purrr::map_dfr(as.character) %>%
    purrr::transpose() %>%
    purrr::map_int(f1)
}

# valid external cause
icd10cm__external_cause_ <- "(^[VWX]\\d....|(?!(Y0[79]))Y[0-3]....|Y07.{1,3}|Y09|(T3[679]9|T414|T427|T4[3579]9)[1-4].|(?!(T3[679]9|T414|T427|T4[3579]9))(T3[6-9]|T4[0-9]|T50)..[1-4]|T1491.{0,1}|(T1[5-9]|T5[1-9]|T6[0-5]|T7[1346])...|T75[0-3]..)(A|$)"

#' Find records with valid external causes of injury icd-10-cm.
#'
#' @param data input data
#' @param diag_ecode_col column indices
#'
#' @return valid_external, a binary variable indicating whether the record has (value = 1) a valid external cause of injury icd-10-cm code
#' @export
#'
#' @examples
#'
#' library(dplyr)
#' library(purrr)
#' set.seed(5)
#' icd10cm_data150 %>%
#' matrix_valid_external(diag_ecode_col = c(2:6)) %>%
#' sample_n(10)
matrix_valid_external <- function(data, diag_ecode_col) {

requireNamespace("dplyr", quietly = T)

icd10cm__external_cause_ <- "(^[VWX]\\d....|(?!(Y0[79]))Y[0-3]....|Y07.{1,3}|Y09|(T3[679]9|T414|T427|T4[3579]9)[1-4].|(?!(T3[679]9|T414|T427|T4[3579]9))(T3[6-9]|T4[0-9]|T50)..[1-4]|T1491.{0,1}|(T1[5-9]|T5[1-9]|T6[0-5]|T7[1346])...|T75[0-3]..)(A|$)"

data %>%
  mutate(valid_external = find_diag(.,
                                       expr = icd10cm__external_cause_,
                                       colvec = diag_ecode_col))
}
