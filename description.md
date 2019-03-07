### How I build our dataset:

``` bash
unzip -p transaction.zip |
  grep -i "HHS" > hhs.csv
```

Then in R:

``` r
library(data.table)

hhs = fread("hhs.csv")
hhs_ca = hhs[hhs$recipient_location_state_code == "CA"]
write.csv(hhs_ca, "hhs_ca.csv")
```
Cleaning the data
-----------------

``` r
hhs_ca = fread('hhs_ca.csv')

# Change all white spaces for NA so it easier to remove them later
hhs_ca[hhs_ca == ""] = NA

# How many transactions have all rows equal NA? 
# All of them have at least one datapoint

sum(rowSums(is.na(hhs_ca)) != ncol(hhs_ca)) 
hhs_ca = hhs_ca[(rowSums(is.na(hhs_ca)) != ncol(hhs_ca))]
```

LOCATION
--------

### POP vs recipient

There are 14 columns that refers to the location of the transaction. There are the ones who start with pop(7) and the ones who start with recipient(7).

POP:

-   pop\_country\_code
-   pop\_country\_name
-   pop\_state\_code
-   pop\_county\_code
-   pop\_county\_name
-   pop\_congressional\_code
-   pop\_zip5

RECIPIENT:

-   recipient\_location\_country\_code
-   recipient\_location\_country\_name
-   recipient\_location\_state\_code
-   recipient\_location\_county\_code
-   recipient\_location\_county\_name
-   recipient\_location\_congressional\_code
-   recipient\_location\_zip5

Both have the same structure but when you look at them they are not equal. It is important to distinguish between pop and recipient because we have built the hhs\_ca based on the recipient\_location\_state\_code but maybe we should do it based on pop\_state\_code. No idea.

``` r
# matrix with only the 'location' columns
location = hhs_ca[, c('pop_country_code', 'recipient_location_country_code', 
                      'pop_country_name', 'recipient_location_country_name',
                      'pop_state_code', 'recipient_location_state_code',
                      'pop_county_code', 'recipient_location_county_code',
                      'pop_county_name', 'recipient_location_county_name',
                      'pop_congressional_code', 'recipient_location_congressional_code',
                      'pop_zip5', 'recipient_location_zip5')]

# ifelse that creates a column with 'nothing' if all the relevant columns are empty
# and 'something' if at least one has information
# only 8 rows dont have any information

location = within(location, diff <- ifelse(is.na(pop_county_code) == TRUE & is.na(pop_county_name) == TRUE &
                                  is.na(pop_zip5) == TRUE & is.na(pop_congressional_code) == TRUE &
                                  is.na(recipient_location_county_code) == TRUE & 
                                  is.na(recipient_location_county_name) == TRUE &
                                  is.na(recipient_location_congressional_code) == TRUE & 
                                  is.na(recipient_location_zip5) == TRUE,
                                  "nothing", 'something'))
```

Idea: Are we able to predict the county based on the transactions each county makes?
------------------------------------------------------------------------------------
