
<!-- README.md is generated from README.Rmd. Please edit that file -->

# injurymatrix

<!-- badges: start -->

<!-- badges: end -->

The R package **injurymatrix** purpose is to facilitate the use of the
[ICD-10-CM injury
matrix](https://www.cdc.gov/nchs/injury/injury_tools.htm) in data
analysis.

The package provides two main functions `matrix_intent()` and
`matrix_mechanism()` to add respectively intent and mechanism of injury
to the inputed data with optional use of keywords. Try
*`?matrix_mechanism`* and *`?matrix_intent`* for more information on
those two functions.

## Installation

To install and load the **injurymatrix** package into your working
environment:

  - Install the devtools package: `install.packages("devtools")`  
  - Install the injurymatrix package:
    `devtools::install_github("epinotes/injurymatrix")`  
  - Load the package: `library(injurymatrix)`

## Examples

``` r

library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.2.1     ✓ purrr   0.3.3
#> ✓ tibble  2.1.3     ✓ dplyr   0.8.4
#> ✓ tidyr   1.0.2     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.4.0
#> ── Conflicts ────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(injurymatrix)

# check the data content

set.seed(11)

icd10cm_data150 %>% sample_n(10)
#> # A tibble: 10 x 6
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr> 
#>  1 007   T405X1A     J9602       J9601       <NA>   <NA>  
#>  2 097   T401X1A     I468        F1120       <NA>   <NA>  
#>  3 107   T426X1A     G92         N179        Y929   <NA>  
#>  4 128   T50992A     J9601       J690        Y92410 <NA>  
#>  5 241   T43621A     I214        K7200       <NA>   <NA>  
#>  6 203   T40601A     J9601       J189        Y92009 <NA>  
#>  7 067   T43212A     R570        T447X2A     Y907   <NA>  
#>  8 033   T40602A     N390        T391X2A     <NA>   <NA>  
#>  9 079   T433X2A     F332        K760        Y92002 <NA>  
#> 10 030   T447X2A     J9600       G9340       <NA>   <NA>

# get the columns with the codes of interest

grep("diag|ecode", names(icd10cm_data150), ignore.case = T)
#> [1] 2 3 4 5 6
# 2 3 4 5 6

# Using matrix_intent(). For more information on the function, try 
# ?matrix_intent 

results_1 <- icd10cm_data150 %>% 
  matrix_intent(inj_col = c(2:6))
  
results_1
#> # A tibble: 150 x 11
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Assault
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>    <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>         0
#>  2 171   T43011A     G92         E860        <NA>   <NA>         0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>         0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>         0
#>  5 026   T43591A     J449        I10         Y92009 <NA>         0
#>  6 172   S72142A     D62         D6832       W010X… Y92018       0
#>  7 129   T8452XA     A419        D693        Y831   <NA>         0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>         0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>         0
#> 10 027   J189        G92         J9600       Y92238 <NA>         0
#> # … with 140 more rows, and 4 more variables: Intentional_Self_Harm <dbl>,
#> #   Legal_Intervention_War <dbl>, Undetermined <dbl>, Unintentional <dbl>

# table of the injury intent from result_1  
results_1 %>%
select(-diagnosis_1:-ecode2) %>%
pivot_longer(cols = -uid,
             names_to = "intent",
             values_to = "count") %>%
group_by(intent) %>%
summarise_at(vars(count), sum)
#> # A tibble: 5 x 2
#>   intent                 count
#>   <chr>                  <dbl>
#> 1 Assault                    0
#> 2 Intentional_Self_Harm     56
#> 3 Legal_Intervention_War     0
#> 4 Undetermined               4
#> 5 Unintentional             78


results_2 <- icd10cm_data150 %>% 
  matrix_intent(inj_col = c(2:6), "unintent", "undeterm")
  
results_2
#> # A tibble: 150 x 8
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Undetermined
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>         <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>              0
#>  2 171   T43011A     G92         E860        <NA>   <NA>              0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>              0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>              0
#>  5 026   T43591A     J449        I10         Y92009 <NA>              0
#>  6 172   S72142A     D62         D6832       W010X… Y92018            0
#>  7 129   T8452XA     A419        D693        Y831   <NA>              0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>              0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>              0
#> 10 027   J189        G92         J9600       Y92238 <NA>              0
#> # … with 140 more rows, and 1 more variable: Unintentional <dbl>

# Using matrix_mechanism(). For more information on the function, try 
# ?matrix_mechanism 

results_3 <- icd10cm_data150 %>% 
  matrix_mechanism(inj_col = c(2:6))
  
results_3
#> # A tibble: 150 x 37
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Bites_Stings_no…
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>             <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>                  0
#>  2 171   T43011A     G92         E860        <NA>   <NA>                  0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>                  0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>                  0
#>  5 026   T43591A     J449        I10         Y92009 <NA>                  0
#>  6 172   S72142A     D62         D6832       W010X… Y92018                0
#>  7 129   T8452XA     A419        D693        Y831   <NA>                  0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>                  0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>                  0
#> 10 027   J189        G92         J9600       Y92238 <NA>                  0
#> # … with 140 more rows, and 30 more variables: Bites_Stings_venomous <dbl>,
#> #   Cut_Pierce <dbl>, Drowning_Submersion <dbl>, Fall <dbl>, Fire_Flame <dbl>,
#> #   Firearm <dbl>, Hot_Object_Substance <dbl>, Machinery <dbl>,
#> #   Motor_Vehicle_Nontraffic <dbl>, MVT_Motorcyclist <dbl>, MVT_Occupant <dbl>,
#> #   MVT_Other <dbl>, MVT_Pedal_Cyclist <dbl>, MVT_Pedestrian <dbl>,
#> #   MVT_Unspecified <dbl>, Natural_Environmental_Other <dbl>,
#> #   Other_Land_Transport <dbl>, Other_Specified_Child_Adult_Abuse <dbl>,
#> #   Other_Specified_Classifiable <dbl>, Other_Specified_Foreign_Body <dbl>,
#> #   Other_Specified_NEC <dbl>, Other_Transport <dbl>, Overexertion <dbl>,
#> #   Pedal_cyclist_other <dbl>, Pedestrian_other <dbl>, Poisoning_Drug <dbl>,
#> #   Poisoning_Non_drug <dbl>, Struck_by_against <dbl>, Suffocation <dbl>,
#> #   Unspecified <dbl>

results_4 <- icd10cm_data150 %>% 
  matrix_mechanism(inj_col = c(2:6), "firearm", "fall", "pierce")
  
results_4
#> # A tibble: 150 x 9
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Cut_Pierce  Fall
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>       <dbl> <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>            0     0
#>  2 171   T43011A     G92         E860        <NA>   <NA>            0     0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>            0     0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>            0     0
#>  5 026   T43591A     J449        I10         Y92009 <NA>            0     0
#>  6 172   S72142A     D62         D6832       W010X… Y92018          0     1
#>  7 129   T8452XA     A419        D693        Y831   <NA>            0     0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>            0     0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>            0     0
#> 10 027   J189        G92         J9600       Y92238 <NA>            0     0
#> # … with 140 more rows, and 1 more variable: Firearm <dbl>

# table of selected mechanisms from result_4
results_4 %>%
select(-diagnosis_1:-ecode2) %>%
pivot_longer(cols = -uid,
             names_to = "mechanism",
             values_to = "count") %>%
group_by(mechanism) %>%
summarise_at(vars(count), sum)
#> # A tibble: 3 x 2
#>   mechanism  count
#>   <chr>      <dbl>
#> 1 Cut_Pierce     2
#> 2 Fall          12
#> 3 Firearm        0
```

## Data included

Explore the following dataset use by the functions above:

`?icd10cm_mech_regex`  
`?icd10cm_intent_regex`  
`?injury_matrix_all`
