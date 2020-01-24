#' Add Selected Intents
#'
#' @param data input data
#' @param inj_col ecode and diagnosis column indices
#' @param ... keyword list
#'
#' @return return the input with additional intent variables
#' @export
#' @importFrom purrr map2_dfc
#'
#' @examples
#' library(dplyr)
#' library(purrr)
#' dat <- data.frame(
#'   d1 = c("T63023", "X92821", "X99100", "T360x"),
#'   d2 = c("T65823", "Y030x0", "T17200", "V0100x")
#' )
#'
#' dat %>% matrix_intent(inj_col = c(1, 2), "untintentional", "assault")
#'
matrix_intent <- function(data, inj_col, ...) {

  requireNamespace("dplyr", quietly = T)
  # utility function making ... a regex

  select_keyword <- function(...){

    if(!length(list(...))){
      keywd <- ""
    }
    else {
      keywd <- paste(list(...), collapse="|")
    }
    keywd
  }

  icd10cm_inj <- icd10cm_intent_regex %>%
    filter(grepl(select_keyword(...), intent, ignore.case = T, perl = T))

  list_int_mech <- icd10cm_inj %>%
    pull(intent_mechanism)

  list_expr <- icd10cm_inj %>% pull(icd10cm_regex)

  # utility function to add field names

  add_field_names <- function(data = data, inj_col, var_name, expr) {
    var_name <- quo_name(var_name)
    data %>%
      mutate(!!var_name := icd_new_diag(., expr = expr, colvec = inj_col)) %>%
      select(!!var_name)
  }

  # add the new fields to the original data

  dat2 <- map2_dfc(.x = list_int_mech, .y = list_expr, ~ add_field_names(data = data, inj_col = inj_col, var_name = .x, expr = .y))

  data %>% bind_cols(dat2)
}
