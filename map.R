
library(ggplot2)
library(tidyverse)
library(urbnmapr)
library(urbnthemes)
library(gganimate)
library(plotly)

#countydata has to be my data
countydata %>% 
  left_join(counties, by = "county_fips") %>% 
  filter(state_name =="California") %>% 
  ggplot(mapping = aes(long, lat, group = group, fill = medhhincome)) + ## medhhincome has to be our total_obligation
  
  # the color in the polygon is the borders between states
  #size: thickness of the border
  geom_polygon(color = "#FFA500", size = .45) +                        # or other variables we want to understand
  scale_fill_gradientn(labels = scales::percent,
                       guide = guide_colorbar(title.position = "top"),
                       colours = terrain.colors(13))  +# colours controls the gradient of colors in the map
  
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + #projects a portion of the earth, which is approximately spherical, onto a flat 2D plane 
  
  theme(legend.title = element_text(colour = "red", size = rel(1.5)), # this changes the color & width of the legend
        legend.key.width = unit(.5, "in"))   +
  labs(fill = "Median income") + #change the name of the variable medhhincome to Homeownership rate
  #set_urbn_defaults() this is specific to urbnthemes
