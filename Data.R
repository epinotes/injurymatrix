
#' Dataset of 92 rows and 3 variables.
#' grouped by intent and mechanism from original with icd10cm code in regular expressions
#'
#' @format Data frame
#' @source modified from the injury matrix "icd10cm_injury_matrix"
#' @keywords datasets
#' @examples
#' head(icd10cm_inj_regex, 10)
"icd10cm_inj_regex"

#' The complete icd10cm injury matrix.
#'
#' Dataset of 3,602 rows and 5 variables.
#' formatted from the original
#'
#' @format Data frame
#' @source
#'   \url{https://www.cdc.gov/injury/wisqars/dataandstats.html}
#'
#' @keywords datasets
#' @examples
#' library(dplyr)
#' sample_n(icd10cm_injury_matrix, 10)
"icd10cm_injury_matrix"

#' icd10cm injury matrix by intent only.
#'
#' Dataset of 5 rows and 2 variables.
#'
#'
#' @format Data frame
#' @source Grouped from icd10cm_inj_regex
#'
#' @keywords datasets
#' @examples
#' icd10cm_intent_regex
"icd10cm_intent_regex"


#' icd10cm injury matrix by mechanism only.
#'
#' Dataset of 31 rows and 3 variables.
#'
#'
#' @format Data frame
#' @source Grouped from icd10cm_inj_regex.
#' @keywords datasets
#' @examples
#' library(dplyr)
#' sample_n(icd10cm_mech_regex, 10)
"icd10cm_mech_regex"

#' The icd10cm injury matrix by intent and mechanism.
#'
#' Dataset of 92 rows and 4 variables.
#' grouped by intent and mechanism from original with icd10cm code in regular expressions
#'
#' @format Data frame
#' @source modified from the injury matrix "icd10cm_injury_matrix"
#' @keywords datasets
#' @examples
#' head(icd10cm_intent_mech_regex, 10)
"icd10cm_intent_mech_regex"

#' Dataset with icd-10-cm codes.
#'
#' Dataset of 150 rows and 3 variables.
#'
#'
#' @format Data frame
#' @source created to use in examples.
#' @keywords datasets
#' @examples
#' icd10cm_data150
"icd10cm_data150"

#' icd-10-cm list and descriptions original.
#'
#' Dataset of 71,932 rows and 3 variables.
#'
#'
#' @format Data frame
#' @source
#'   \url{https://www.cms.gov/Medicare/Coding/ICD10/2019-ICD-10-CM}
#' @keywords datasets
#' @examples
#' tail(icd10cm_codes_2019)

"icd10cm_codes_2019"


#' County FIPS codes for WA State.
#'
#' Dataset of 39 rows and 7 variables.
#'
#'
#' @format Data frame
#' @source
#'   US Census Bureau Through the R package"tidycensus"
#' @keywords datasets
#' @examples
#' head(wa_fips_codes)
#'
"wa_fips_codes"
