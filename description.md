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

LOCATION
--------

``` r
hhs_ca = fread('/Users/rodrigo/Documents/Big-Data/final-project/hhs_ca/hhs_ca.csv')

length(unique(hhs_ca$recipient_location_county_code))
length(unique(hhs_ca$recipient_location_county_name))
length(unique(hhs_ca$recipient_location_congressional_code))

#ZIP
length(unique(hhs_ca$recipient_location_zip5))
length(unique(hhs_ca$pop_zip5))
```

Within California, there are 163 differents congressional districts, 114 county names, 59 county codes. We also have 1135 different ZIP codes and 2001 different pop\_zip codes. We need to understand how this works if we want to subdivide by counties. I think it would be interesting to study the difference and heterogeneity in medical spending between rich/poor or other socioeconomic factors.
