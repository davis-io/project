
library(ggplot2)
library(tidyverse)
library(urbnmapr)
library(urbnthemes) # don't install it
library(gganimate)
library(plotly)

####################################################################################
####################################################################################

#example with data from urbnmapr

#countydata has to be my data
countydata %>% 
  left_join(counties, by = "county_fips") %>% 
  filter(state_name =="California") %>% 
  ggplot(mapping = aes(long, lat, group = group, fill = medhhincome)) + # medhhincome has to be our total_obligation
  
  # the color in the polygon is the borders between states
  #size: thickness of the border
  geom_polygon(color = "#FFA500", size = .45) +                        
  scale_fill_gradientn(labels = scales::percent,
                       guide = guide_colorbar(title.position = "top"),
                       colours = terrain.colors(13))  +  # colours controls the gradient of colors in the map
  
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + #projects a portion of the earth, which is approximately spherical, onto a flat 2D plane 
  
  theme(legend.title = element_text(colour = "red", size = rel(1.5)), # this changes the color & width of the legend
        legend.key.width = unit(.5, "in"))   +
  labs(fill = "Median income") + #change the name of the variable medhhincome to Homeownership rate
  #set_urbn_defaults() this is specific to urbnthemes


####################################################################################
####################################################################################

# map with our data

hhs_ca = hhs_ca %>%
    filter(awarding_toptier_agency_abbreviation == "HHS") %>% # 3000 are not HHS (problem with grep)
    filter(!is.na(recipient_location_county_code)) %>%        # only the ones that are not NA
    filter(fiscal_year != 2019) %>%                           # remove 2019
    select(c("fiscal_year", "recipient_location_county_code", "total_obligation")) %>%
    rename(county_fips = recipient_location_county_code)

#change fips
hhs_ca = transform(hhs_ca, county_fips = ifelse(county_fips <11,
                                                  paste("0600" , as.character(county_fips), sep = ""),county_fips))
hhs_ca = transform(hhs_ca, county_fips = ifelse(as.numeric(county_fips) > 10 & as.numeric(county_fips) < 100,
                                                  paste("060" , as.character(county_fips), sep = ""), county_fips))
hhs_ca = transform(hhs_ca, county_fips = ifelse(as.numeric(county_fips) > 100 & as.numeric(county_fips) < 150,
                                                  paste("06" , as.character(county_fips), sep = ""), county_fips))


#aggregate by year and county code
# problem: not all counties have data for all years. Not very common though.
# There should be 58*18 = 1044 observations, there are 958. Some are missing.
agg_map = aggregate(total_obligation ~ fiscal_year + county_fips, hhs_ca, median, na.rn = TRUE)

# join agg_map with shapefile of counties
df_map = left_join(agg_map, counties, by = "county_fips")

#only take one year here to make the graph (2015)
df_map_2015 = df_map[df_map$fiscal_year == 2015 , ]

# map
# it is not perfect and there may be errors. 
# we need to customize it
# we need to animate it with plotly

ggplot(mapping = aes(df_map_2015$long, df_map_2015$lat, group = df_map_2015$group, fill = df_map_2015$total_obligation)) + 
  geom_polygon(color = "#FFA500", size = .45) +                        
  scale_fill_gradientn(labels = scales::percent,
                       guide = guide_colorbar(title.position = "top"),
                       colours = terrain.colors(13))  +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
  theme(legend.title = element_text(colour = "red", size = rel(1.5)), 
        legend.key.width = unit(.5, "in"))   +
  labs(fill = "median obligation")







