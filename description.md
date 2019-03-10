
### IDEA 1: Inside CA, only 77% of the transactions report the county location. First, we try to find regularities in the data including socioceconomic factors. Are richer/older counties spend money differently than poorer/younger counties? How long between action date and last\_modified\_date? Different types of contracts? Create a CA map with different counties summarizing what we found.

### IDEA 2: If I tell you the description of the transaction, type of contract and so on ... are you able to predict the county where it is supposed to be located? Can we build a good classifier?

### How I built our dataset: 
Should we do it using SQL so we know tht we are using the right data?  Using grep seems not very robust. Maybe you can do it because you haave more experience with SQL.

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

**Difference found: POP means place of performance. We should use recipient.**

DETAILS ABOUT THE DATA
--------

Percentage of NA with respect to the total number of rows for each row?
We shouldn't use columns with litle information.

``` r
for (name in colnames(hhs_ca)){
  print(paste(name,sum(is.na(hhs_ca[[name]]))/dim(hhs_ca)[1], sep =": "))
}

#[1] "recipient_unique_id: 0.154898496951364"
#[1] "transaction_id: 0"
#[1] "action_date: 0"
#[1] "last_modified_date: 0"
#[1] "fiscal_year: 0"
#[1] "award_id: 0"
#[1] "generated_pragmatic_obligation: 0"
#[1] "total_obligation: 0"
#[1] "total_subsidy_cost: 0.676516637519497"
#[1] "total_loan_value: 0.934841305478092"
#[1] "total_obl_bin: 0"
#[1] "federal_action_obligation: 0"
#[1] "original_loan_subsidy_cost: 0"
#[1] "face_value_loan_guarantee: 0"
#[1] "recipient_id: 0"
#[1] "recipient_hash: 0"
#[1] "awarding_agency_id: 0"
#[1] "funding_agency_id: 0.713575885049865"
#[1] "type: 0.0172578815522049"
#[1] "action_type: 0.226934347969939"
#[1] "award_category: 0.0172549274471806"
#[1] "fain: 0.36575365127381"
#[1] "uri: 0.985459895070189"
#[1] "piid: 0.648786453656"
#[1] "transaction_description: 0.163415181736541"
#[1] "modification_number: 0.154798057380536"
#[1] "pop_country_code: 0.212098832537694"
#[1] "pop_country_name: 0.212098832537694"
#[1] "pop_state_code: 0.241099281561658"
#[1] "pop_county_code: 0.304739566101054"
#[1] "pop_county_name: 0.159991374013329"
#[1] "pop_zip5: 0.337784184903342"
#[1] "pop_congressional_code: 0.0540867088906745"
#[1] "recipient_location_country_code: 0.185423264167888"
#[1] "recipient_location_country_name: 0.37463959918703"
#[1] "recipient_location_state_code: 0"
#[1] "recipient_location_county_code: 0.228375951221818"
#[1] "recipient_location_county_name: 0.189564919412015"
#[1] "recipient_location_congressional_code: 0.21474275653448"
#[1] "recipient_location_zip5: 0.203839154889635"
#[1] "naics_code: 0.672888996549605"
#[1] "naics_description: 0.674693954719478"
#[1] "product_or_service_code: 0.65794417923146"
#[1] "product_or_service_description: 0.65794417923146"
#[1] "pulled_from: 0.648786453656"
#[1] "type_of_contract_pricing: 0.65275972491374"
#[1] "type_set_aside: 0.681875384033653"
#[1] "extent_competed: 0.669790140379071"
#[1] "cfda_number: 0.351213546344"
#[1] "cfda_title: 0.36952308928487"
#[1] "recipient_name: 0"
#[1] "parent_recipient_unique_id: 0.240233728789526"
#[1] "awarding_toptier_agency_name: 0"
#[1] "funding_toptier_agency_name: 0.713575885049865"
#[1] "awarding_subtier_agency_name: 0"
#[1] "funding_subtier_agency_name: 0.713575885049865"
#[1] "awarding_toptier_agency_abbreviation: 0"
#[1] "funding_toptier_agency_abbreviation: 0.713575885049865"
#[1] "awarding_subtier_agency_abbreviation: 0.00820059554757291"
#[1] "funding_subtier_agency_abbreviation: 0.717859337335161"
#[1] "business_categories: 0.0415849364276599"
```

