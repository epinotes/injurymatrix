
# injurymatrix

The R package
**[injurymatrix](https://epinotes.github.io/injurymatrix/)** purpose is
to facilitate the use of the **ICD-10-CM injury matrix**in data
analysis. The online matrices were updated in October 2020(
<ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/injury/tools/>).

The package provides three main functions: `matrix_intent()`,
`matrix_mechanism()` and `matrix_intent_mechanism()` to add respectively
intent only, mechanism only, and combination of intent and mechanism of
injury to the inputed data. The analyst has the option to use keywords
to limit the query of intent or mechanism. Try *`?matrix_intent`*,
*`?matrix_mechanism`* and *`?matrix_intent_mechanism`* for more
information on those functions. There are more capabilities in the
package [useicd10cm](https://github.com/epinotes/useicd10cm) to
consider.

## Installation

To install and load the **injurymatrix** package into your working
environment:

  - Install the devtools package: `install.packages("devtools")`  
  - Install the injurymatrix package:
    `devtools::install_github("epinotes/injurymatrix")`  
  - Load the package: `library(injurymatrix)`

## Examples

``` r
# loading relevant packages  

library(tidyverse)
#> -- Attaching packages ---------------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.2          v purrr   0.3.4     
#> v tibble  3.0.1.9000     v dplyr   1.0.0     
#> v tidyr   1.1.0          v stringr 1.4.0     
#> v readr   1.3.1          v forcats 0.5.0
#> -- Conflicts ------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
library(injurymatrix)
```

``` r
# check the content of the dataset used in the examples below.   

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

# get the indices of the columns with ICD-10_CM. 

grep("diag|ecode", names(icd10cm_data150), ignore.case = T)
#> [1] 2 3 4 5 6

# The indices will be used as arguments in the following functions.  
```

### Using `matrix_intent()`

  - Without keyword submitted, all the five injury intents are added to
    the data.  
  - With keywords (the partial name of the intent will suffice) only the
    matching intents will be added to the dataset.

<!-- end list -->

``` r
# ?matrix_intent for more information

# No keyword is used

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
#>  6 172   S72142A     D62         D6832       W010X~ Y92018       0
#>  7 129   T8452XA     A419        D693        Y831   <NA>         0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>         0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>         0
#> 10 027   J189        G92         J9600       Y92238 <NA>         0
#> # ... with 140 more rows, and 4 more variables: `Intentional Self-harm` <dbl>,
#> #   `Legal Intervention-War` <dbl>, Undetermined <dbl>, Unintentional <dbl>

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
#> 2 Intentional Self-harm     56
#> 3 Legal Intervention-War     0
#> 4 Undetermined               4
#> 5 Unintentional             78

# Keywords used  

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
#>  6 172   S72142A     D62         D6832       W010X~ Y92018            0
#>  7 129   T8452XA     A419        D693        Y831   <NA>              0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>              0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>              0
#> 10 027   J189        G92         J9600       Y92238 <NA>              0
#> # ... with 140 more rows, and 1 more variable: Unintentional <dbl>
```

### Using `matrix_mechanism()`

  - Without keyword submitted, all the 33 injury mechanisms are added to
    the data.  
  - With keywords (the partial name of the mechanism will suffice) only
    the matching mechanisms will be added to the dataset.

<!-- end list -->

``` r

# ?matrix_mechanism for more information 

# No keyword 

results_3 <- icd10cm_data150 %>% 
  matrix_mechanism(inj_col = c(2:6))
#> New names:
#> * Natural_Environmental_Other -> Natural_Environmental_Other...18
#> * Natural_Environmental_Other -> Natural_Environmental_Other...19
#> New names:
#> * Natural_Environmental_Other...18 -> Natural_Environmental_Other...24
#> * Natural_Environmental_Other...19 -> Natural_Environmental_Other...25
  
results_3
#> # A tibble: 150 x 39
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Bites_and_Sting~
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>             <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>                  0
#>  2 171   T43011A     G92         E860        <NA>   <NA>                  0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>                  0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>                  0
#>  5 026   T43591A     J449        I10         Y92009 <NA>                  0
#>  6 172   S72142A     D62         D6832       W010X~ Y92018                0
#>  7 129   T8452XA     A419        D693        Y831   <NA>                  0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>                  0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>                  0
#> 10 027   J189        G92         J9600       Y92238 <NA>                  0
#> # ... with 140 more rows, and 32 more variables:
#> #   Bites_and_Stings_venomous <dbl>, Bites_Stings_venomous <dbl>,
#> #   Cut_Pierce <dbl>, Drowning_Submersion <dbl>, Fall <dbl>, Fire_Flame <dbl>,
#> #   Firearm <dbl>, Hot_Object_Substance <dbl>, Machinery <dbl>,
#> #   Motor_Vehicle_Nontraffic <dbl>, MVT_Motorcyclist <dbl>, MVT_Occupant <dbl>,
#> #   MVT_Other <dbl>, MVT_Pedal_Cyclist <dbl>, MVT_Pedestrian <dbl>,
#> #   MVT_Unspecified <dbl>, Natural_Environmental_Other...24 <dbl>,
#> #   Natural_Environmental_Other...25 <dbl>, Other_Land_Transport <dbl>,
#> #   Other_Specified_Child_Adult_Abuse <dbl>,
#> #   Other_Specified_Classifiable <dbl>, Other_Specified_Foreign_Body <dbl>,
#> #   Other_Specified_NEC <dbl>, Other_Transport <dbl>, Overexertion <dbl>,
#> #   Pedal_cyclist_other <dbl>, Pedestrian_other <dbl>, Poisoning_Drug <dbl>,
#> #   Poisoning_Non_drug <dbl>, Struck_by_against <dbl>, Suffocation <dbl>,
#> #   Unspecified <dbl>

# Keyword used

results_4 <- icd10cm_data150 %>% 
  matrix_mechanism(inj_col = c(2:6), "drug", "fall", "pierce")
  
results_4
#> # A tibble: 150 x 10
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Cut_Pierce  Fall
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>       <dbl> <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>            0     0
#>  2 171   T43011A     G92         E860        <NA>   <NA>            0     0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>            0     0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>            0     0
#>  5 026   T43591A     J449        I10         Y92009 <NA>            0     0
#>  6 172   S72142A     D62         D6832       W010X~ Y92018          0     1
#>  7 129   T8452XA     A419        D693        Y831   <NA>            0     0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>            0     0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>            0     0
#> 10 027   J189        G92         J9600       Y92238 <NA>            0     0
#> # ... with 140 more rows, and 2 more variables: Poisoning_Drug <dbl>,
#> #   Poisoning_Non_drug <dbl>

# table of selected mechanisms from result_4  

results_4 %>%
select(-diagnosis_1:-ecode2) %>%
pivot_longer(cols = -uid,
             names_to = "mechanism",
             values_to = "count") %>%
group_by(mechanism) %>%
summarise_at(vars(count), sum)
#> # A tibble: 4 x 2
#>   mechanism          count
#>   <chr>              <dbl>
#> 1 Cut_Pierce             2
#> 2 Fall                  12
#> 3 Poisoning_Drug       118
#> 4 Poisoning_Non_drug     0
```

### Using `matrix_intent_mechanism()`

  - Without keyword submitted, all the 92 injury intents and mechanisms
    combined are added to the data.  
  - With keywords (the partial name of the mechanism or intent will
    suffice) only the matching combination of intent and mechanisms will
    be added to the dataset.

<!-- end list -->

``` r

# ?matrix_mechanism for more information 

# No keyword 

results_5 <- icd10cm_data150 %>% 
  matrix_intent_mechanism(inj_col = c(2:6))
  
results_5
#> # A tibble: 150 x 98
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Assault_Bites_S~
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>             <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>                  0
#>  2 171   T43011A     G92         E860        <NA>   <NA>                  0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>                  0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>                  0
#>  5 026   T43591A     J449        I10         Y92009 <NA>                  0
#>  6 172   S72142A     D62         D6832       W010X~ Y92018                0
#>  7 129   T8452XA     A419        D693        Y831   <NA>                  0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>                  0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>                  0
#> 10 027   J189        G92         J9600       Y92238 <NA>                  0
#> # ... with 140 more rows, and 91 more variables: Assault_Cut_Pierce <dbl>,
#> #   Assault_Drowning_Submersion <dbl>, Assault_Fall <dbl>,
#> #   Assault_Fire_Flame <dbl>, Assault_Firearm <dbl>,
#> #   Assault_Hot_Object_Substance <dbl>, Assault_MVT_Occupant <dbl>,
#> #   Assault_MVT_Pedestrian <dbl>, Assault_Natural_Environmental_Other <dbl>,
#> #   Assault_Other_Land_Transport <dbl>,
#> #   Assault_Other_Specified_Child_Adult_Abuse <dbl>,
#> #   Assault_Other_Specified_Classifiable <dbl>,
#> #   Assault_Other_Specified_NEC <dbl>, Assault_Other_Transport <dbl>,
#> #   Assault_Poisoning_Drug <dbl>, Assault_Poisoning_Non_drug <dbl>,
#> #   Assault_Struck_by_against <dbl>, Assault_Suffocation <dbl>,
#> #   Assault_Unspecified <dbl>, `Intentional
#> #   Self-harm_Bites_and_Stings_venomous` <dbl>, `Intentional
#> #   Self-harm_Cut_Pierce` <dbl>, `Intentional
#> #   Self-harm_Drowning_Submersion` <dbl>, `Intentional Self-harm_Fall` <dbl>,
#> #   `Intentional Self-harm_Fire_Flame` <dbl>, `Intentional
#> #   Self-harm_Firearm` <dbl>, `Intentional
#> #   Self-harm_Hot_Object_Substance` <dbl>, `Intentional
#> #   Self-harm_MVT_Occupant` <dbl>, `Intentional Self-harm_MVT_Other` <dbl>,
#> #   `Intentional Self-harm_Natural_Environmental_Other` <dbl>, `Intentional
#> #   Self-harm_Other_Land_Transport` <dbl>, `Intentional
#> #   Self-harm_Other_Specified_Classifiable` <dbl>, `Intentional
#> #   Self-harm_Other_Specified_NEC` <dbl>, `Intentional
#> #   Self-harm_Other_Transport` <dbl>, `Intentional
#> #   Self-harm_Poisoning_Drug` <dbl>, `Intentional
#> #   Self-harm_Poisoning_Non_drug` <dbl>, `Intentional
#> #   Self-harm_Struck_by_against` <dbl>, `Intentional
#> #   Self-harm_Suffocation` <dbl>, `Intentional Self-harm_Unspecified` <dbl>,
#> #   `Legal Intervention-War_Cut_Pierce` <dbl>, `Legal
#> #   Intervention-War_Fire_Flame` <dbl>, `Legal Intervention-War_Firearm` <dbl>,
#> #   `Legal Intervention-War_Other_Specified_Classifiable` <dbl>, `Legal
#> #   Intervention-War_Other_Specified_NEC` <dbl>, `Legal
#> #   Intervention-War_Other_Transport` <dbl>, `Legal
#> #   Intervention-War_Poisoning_Non_drug` <dbl>, `Legal
#> #   Intervention-War_Struck_by_against` <dbl>, `Legal
#> #   Intervention-War_Suffocation` <dbl>, `Legal
#> #   Intervention-War_Unspecified` <dbl>,
#> #   Undetermined_Bites_and_Stings_venomous <dbl>,
#> #   Undetermined_Cut_Pierce <dbl>, Undetermined_Drowning_Submersion <dbl>,
#> #   Undetermined_Fall <dbl>, Undetermined_Fire_Flame <dbl>,
#> #   Undetermined_Firearm <dbl>, Undetermined_Hot_Object_Substance <dbl>,
#> #   Undetermined_MVT_Unspecified <dbl>,
#> #   Undetermined_Natural_Environmental_Other <dbl>,
#> #   Undetermined_Other_Specified_Classifiable <dbl>,
#> #   Undetermined_Other_Specified_NEC <dbl>, Undetermined_Poisoning_Drug <dbl>,
#> #   Undetermined_Poisoning_Non_drug <dbl>,
#> #   Undetermined_Struck_by_against <dbl>, Undetermined_Suffocation <dbl>,
#> #   Unintentional_Bites_and_Stings_nonvenomous <dbl>,
#> #   Unintentional_Bites_and_Stings_venomous <dbl>,
#> #   Unintentional_Cut_Pierce <dbl>, Unintentional_Drowning_Submersion <dbl>,
#> #   Unintentional_Fall <dbl>, Unintentional_Fire_Flame <dbl>,
#> #   Unintentional_Firearm <dbl>, Unintentional_Hot_Object_Substance <dbl>,
#> #   Unintentional_Machinery <dbl>,
#> #   Unintentional_Motor_Vehicle_Nontraffic <dbl>,
#> #   Unintentional_MVT_Motorcyclist <dbl>, Unintentional_MVT_Occupant <dbl>,
#> #   Unintentional_MVT_Other <dbl>, Unintentional_MVT_Pedal_Cyclist <dbl>,
#> #   Unintentional_MVT_Pedestrian <dbl>,
#> #   Unintentional_Natural_Environmental_Other <dbl>,
#> #   Unintentional_Other_Land_Transport <dbl>,
#> #   Unintentional_Other_Specified_Classifiable <dbl>,
#> #   Unintentional_Other_Specified_Foreign_Body <dbl>,
#> #   Unintentional_Other_Transport <dbl>, Unintentional_Overexertion <dbl>,
#> #   Unintentional_Pedal_cyclist_other <dbl>,
#> #   Unintentional_Pedestrian_other <dbl>, Unintentional_Poisoning_Drug <dbl>,
#> #   Unintentional_Poisoning_Non_drug <dbl>,
#> #   Unintentional_Struck_by_against <dbl>, Unintentional_Suffocation <dbl>,
#> #   Unintentional_Unspecified <dbl>

# Keyword used

results_6 <- icd10cm_data150 %>% 
  matrix_intent_mechanism(inj_col = c(2:6), "Poisoning_Drug")
  
results_6
#> # A tibble: 150 x 10
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 Assault_Poisoni~
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>             <dbl>
#>  1 051   T82868A     N186        D6859       Y832   <NA>                  0
#>  2 171   T43011A     G92         E860        <NA>   <NA>                  0
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>                  0
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>                  0
#>  5 026   T43591A     J449        I10         Y92009 <NA>                  0
#>  6 172   S72142A     D62         D6832       W010X~ Y92018                0
#>  7 129   T8452XA     A419        D693        Y831   <NA>                  0
#>  8 197   T43621A     R7881       E876        <NA>   <NA>                  0
#>  9 232   T50902A     J9601       G92         Y9259  <NA>                  0
#> 10 027   J189        G92         J9600       Y92238 <NA>                  0
#> # ... with 140 more rows, and 3 more variables: `Intentional
#> #   Self-harm_Poisoning_Drug` <dbl>, Undetermined_Poisoning_Drug <dbl>,
#> #   Unintentional_Poisoning_Drug <dbl>

# table of selected mechanisms from result_4  

results_6 %>%
select(-diagnosis_1:-ecode2) %>%
pivot_longer(cols = -uid,
             names_to = "intent_mechanism",
             values_to = "count") %>%
group_by(intent_mechanism) %>%
summarise_at(vars(count), sum)
#> # A tibble: 4 x 2
#>   intent_mechanism                     count
#>   <chr>                                <dbl>
#> 1 Assault_Poisoning_Drug                   0
#> 2 Intentional Self-harm_Poisoning_Drug    56
#> 3 Undetermined_Poisoning_Drug              4
#> 4 Unintentional_Poisoning_Drug            58
```

### Create A column of first valid external cause

This example illustrates how to create a first valid external cause
field.

``` r
icd10cm__external_cause_ <- "(^[VWX]\\d....|(?!(Y0[79]))Y[0-3]....|Y07.{1,3}|Y09|(T3[679]9|T414|T427|T4[3579]9)[1-4].|(?!(T3[679]9|T414|T427|T4[3579]9))(T3[6-9]|T4[0-9]|T50)..[1-4]|T1491.{0,1}|(T1[5-9]|T5[1-9]|T6[0-5]|T7[1346])...|T75[0-3]..)(A|$)"
```

The function `icd_first_valid_regex()` in combination with the regular
expression above, `icd10cm__external_cause_` (It is in the [CSTE
Toolkit](https://resources.cste.org/ICD-10-CM/Standardized%20Validation%20Datasets/Other%20Useful%20ICD-10-CM%20Regular%20Expressions.pdf))
will create the first valid external cause field.

``` r
results_7 <- icd10cm_data150 %>% 
  mutate(ex_cause1 = icd_first_valid_regex(., colvec = c(2:6), 
                                           pattern = icd10cm__external_cause_))

results_7
#> # A tibble: 150 x 7
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1  ecode2 ex_cause1
#>    <chr> <chr>       <chr>       <chr>       <chr>   <chr>  <chr>    
#>  1 051   T82868A     N186        D6859       Y832    <NA>   <NA>     
#>  2 171   T43011A     G92         E860        <NA>    <NA>   T43011A  
#>  3 228   T391X1A     D72829      E785        Y92009  <NA>   T391X1A  
#>  4 071   T383X2A     T471X2A     F329        <NA>    <NA>   T383X2A  
#>  5 026   T43591A     J449        I10         Y92009  <NA>   T43591A  
#>  6 172   S72142A     D62         D6832       W010XXA Y92018 W010XXA  
#>  7 129   T8452XA     A419        D693        Y831    <NA>   <NA>     
#>  8 197   T43621A     R7881       E876        <NA>    <NA>   T43621A  
#>  9 232   T50902A     J9601       G92         Y9259   <NA>   T50902A  
#> 10 027   J189        G92         J9600       Y92238  <NA>   <NA>     
#> # ... with 140 more rows
```

Adding selected intents to *results\_7* by using the new *ex\_cause1*
only:

``` r
results_7 %>% 
  matrix_intent(inj_col = "ex_cause1", 
                "unintent", "undeterm")
#> # A tibble: 150 x 9
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1 ecode2 ex_cause1
#>    <chr> <chr>       <chr>       <chr>       <chr>  <chr>  <chr>    
#>  1 051   T82868A     N186        D6859       Y832   <NA>   <NA>     
#>  2 171   T43011A     G92         E860        <NA>   <NA>   T43011A  
#>  3 228   T391X1A     D72829      E785        Y92009 <NA>   T391X1A  
#>  4 071   T383X2A     T471X2A     F329        <NA>   <NA>   T383X2A  
#>  5 026   T43591A     J449        I10         Y92009 <NA>   T43591A  
#>  6 172   S72142A     D62         D6832       W010X~ Y92018 W010XXA  
#>  7 129   T8452XA     A419        D693        Y831   <NA>   <NA>     
#>  8 197   T43621A     R7881       E876        <NA>   <NA>   T43621A  
#>  9 232   T50902A     J9601       G92         Y9259  <NA>   T50902A  
#> 10 027   J189        G92         J9600       Y92238 <NA>   <NA>     
#> # ... with 140 more rows, and 2 more variables: Undetermined <dbl>,
#> #   Unintentional <dbl>
```

### Filter A Dataset With Valid External Cause Of Injury ICD 10 CM

Using the function `matrix_valid_external()` providing the columns with
the icd-10-cm of interest.

``` r
# create a new binary variable "valid_external"  

results_8 <- icd10cm_data150 %>% 
   matrix_valid_external(c(2:6))

results_8
#> # A tibble: 150 x 7
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1  ecode2 valid_external
#>    <chr> <chr>       <chr>       <chr>       <chr>   <chr>           <dbl>
#>  1 051   T82868A     N186        D6859       Y832    <NA>                0
#>  2 171   T43011A     G92         E860        <NA>    <NA>                1
#>  3 228   T391X1A     D72829      E785        Y92009  <NA>                1
#>  4 071   T383X2A     T471X2A     F329        <NA>    <NA>                1
#>  5 026   T43591A     J449        I10         Y92009  <NA>                1
#>  6 172   S72142A     D62         D6832       W010XXA Y92018              1
#>  7 129   T8452XA     A419        D693        Y831    <NA>                0
#>  8 197   T43621A     R7881       E876        <NA>    <NA>                1
#>  9 232   T50902A     J9601       G92         Y9259   <NA>                1
#> 10 027   J189        G92         J9600       Y92238  <NA>                0
#> # ... with 140 more rows

# count the number of records with valid external cause of injury
results_8 %>% 
  count(valid_external)
#> # A tibble: 2 x 2
#>   valid_external     n
#>            <dbl> <int>
#> 1              0    14
#> 2              1   136

# Subset the dataset to the 136 records with valid external causes of injury.

results_8 %>% 
  filter(valid_external == 1)
#> # A tibble: 136 x 7
#>    uid   diagnosis_1 diagnosis_2 diagnosis_3 ecode1  ecode2  valid_external
#>    <chr> <chr>       <chr>       <chr>       <chr>   <chr>            <dbl>
#>  1 171   T43011A     G92         E860        <NA>    <NA>                 1
#>  2 228   T391X1A     D72829      E785        Y92009  <NA>                 1
#>  3 071   T383X2A     T471X2A     F329        <NA>    <NA>                 1
#>  4 026   T43591A     J449        I10         Y92009  <NA>                 1
#>  5 172   S72142A     D62         D6832       W010XXA Y92018               1
#>  6 197   T43621A     R7881       E876        <NA>    <NA>                 1
#>  7 232   T50902A     J9601       G92         Y9259   <NA>                 1
#>  8 066   T43012A     J9692       J690        Y92019  W1839XA              1
#>  9 118   S32810A     S06340A     I2699       V0319XA <NA>                 1
#> 10 076   T43622A     J9600       T40992A     <NA>    <NA>                 1
#> # ... with 126 more rows
```

## Data included in the `injurymatrix` package

Exploring the datasets below that provided the necessary information
used by the functions described above. Run the following lines of code
to get more details on the datasets.

`library(injurymatix)`  
`?icd10cm_mech_regex` \# matrix collapsed to the 33 mechanisms  
`?icd10cm_intent_regex` \# matrix collapsed to the 5 intents
`?icd10cm_intent_mech_regex` \# matrix of the 92 combinations of intent
and mechanism `?injury_matrix_all` \# the full matrix of 3,655 entries
ICD-10-CM of external causes of injury
