
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

icd_new_diag <- function(data, expr, colvec, ignore.case = T, perl = T) {

  requireNamespace("dplyr", quietly = T)

  # colvec <- enquo(colvec)
  # assign '1' if the regular expression matched
  f1 <- function(x) grepl(expr, x, ignore.case = ignore.case, perl = perl)
  # any 1 in the diagnosis field suffices
  f2 <- function(x){
    sign(rowSums(x, na.rm = TRUE))
  }

  data %>% as_tibble() %>%
    select({{colvec}}) %>%
    mutate_all(as.character) %>%
    furrr::future_map_dfr(f1) %>%
    transmute(new_diag = f2(.)) %>%
    flatten_dbl()
}
