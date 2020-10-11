#' The complete icd10cm injury matrix.
#'
#' Dataset of 3,655 rows and 5 variables.
#' formatted from the original
#'
#' @format Data frame
#' @source
#'   \url{ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/injury/tools/}
#'
#' @keywords datasets
#' @examples
#' library(dplyr)
#' sample_n(injury_matrix_all, 10)
"injury_matrix_all"


#' icd10cm injury matrix by intent only.
#'
#' Dataset of 5 rows and 3 variables.
#'
#'
#' @format Data frame
#' @source Grouped from injury_matrix_all
#'
#' @keywords datasets
#' @examples
#' icd10cm_intent_regex
"icd10cm_intent_regex"


#' icd10cm injury matrix by mechanism only.
#'
#' Dataset of 33 rows and 3 variables.
#'
#'
#' @format Data frame
#' @source Grouped from injury_matrix_all.
#' @keywords datasets
#' @examples
#' library(dplyr)
#' sample_n(icd10cm_mech_regex, 10)
"icd10cm_mech_regex"

#' icd10cm injury matrix by intent and mechanism combined.
#'
#' Dataset of 92 rows and 4 variables.
#'
#'
#' @format Data frame
#' @source Grouped from injury_matrix_all.
#' @keywords datasets
#' @examples
#' library(dplyr)
#' sample_n(icd10cm_intent_mech_regex, 10)
"icd10cm_intent_mech_regex"


#' Dataset with icd-10-cm codes.
#'
#' Dataset of 150 rows and 6 variables.
#'
#'
#' @format Data frame
#' @source created to use in examples.
#' @keywords datasets
#' @examples
#' icd10cm_data150
"icd10cm_data150"
