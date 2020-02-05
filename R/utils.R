icd_make_regex <- purrr::compose(
  function(x) gsub("X", "^X", x),
  function(x) paste(x, collapse = "|"),
  function(x) gsub("(?<!^)x", ".", x, ignore.case = T, perl = T)
)


icd_clean_mech_names <- purrr::compose(
  # remove repeat "_" and extreme "_"
  function(x) gsub("(_)(?=_*\\1)|^_|_$", "", x, perl = T),
  # not [A-Za-z0-9_] and replace with "_"
  function(x) gsub("\\W", "_", x),
  # parenthesis and its contents
  function(x) gsub("\\(.+\\)", "", x)
)
