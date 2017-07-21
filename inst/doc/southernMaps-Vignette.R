## ---- fig.cap= "A low-res map of NZ in base map", fig.width = 8, fig.height = 6----
par(mfrow = c(1, 2))
plot(nzSml84)
plot(nzSml84, axes = TRUE) # with basic axes
par(mfrow = c(1,1))

## ------------------------------------------------------------------------
nz_DF84 <- fortify_polygons(shape = nzSml84, proj = "wgs84")

## ------------------------------------------------------------------------
nz_DF <- fortify_polygons(shape = nzSml84, proj = "nztm")

require(ggplot2)

ggplot(nz_DF, aes(x = long, y = lat)) + 
  geom_polygon() + 
  theme_minimal()

## ------------------------------------------------------------------------

ggplot(nz_DF84, aes(x = long, y = lat)) + 
  geom_polygon(aes(group = group)) + 
  theme_minimal() +
  coord_map() + 
  labs(x = "Longitude E", y = "Latitude S") +
  theme(panel.grid = element_blank())


## ------------------------------------------------------------------------
isle <- find_my_island("codfish", proj = "nztm")
plot(isle)

## ------------------------------------------------------------------------
isle_df <- fortify_polygons(isle, "wgs84")

idf <- ggplot(isle_df, aes(x = long, y = lat)) +
  geom_polygon(colour = "grey", fill = "white")+
  coord_map() + 
  labs(x = "Longitude E", y = "Latitude S", 
       title = "Codfish Island") 

idf

## ------------------------------------------------------------------------
# multiple islands
many <- find_my_island(c("auckland", "campbell")) %>%
  fortify_polygons("nztm")

# the chain command %>% is from dplyr
# just skips the intermediate assignment

ggplot(many, aes(x = long,y  = lat)) +
  geom_path(aes(group = group)) +
  coord_equal() + 
  labs(title = "Offshore islands", subtitle = "Auckland and Campbell islands") + 
  theme_void() # no axes, nothing 

## ---- fig.width = 8, fig.height = 7--------------------------------------

some_points <- data.frame(longitude = runif(8, min = min(isle_df$long) + 0.0001, max = max(isle_df$long) - 0.0001),
                          latitude = runif(8, min = min(isle_df$lat) + 0.0001, max = max(isle_df$lat) - 0.0001),
                          type = c(rep("Control", 4), rep("Treatment", 4)),
                          siteName = c("Umbrella", "Peach", "Car", "Dog", "Film", "Laptop", "Backpack", "Plate"))

idf +
  geom_point(data = some_points, aes(x = longitude, y = latitude, fill = type),
             shape = 21, colour = "black") +
  scale_fill_manual(values = c("black", "white")) +
  theme(legend.position = "bottom") +
  labs(fill = "Treatment") +
  geom_text(data = some_points %>% filter(siteName != "Backpack"), aes(x = longitude, y = latitude, label = siteName),
            nudge_x = 0.001, 
            hjust = 0) +
    geom_text(data = some_points %>% filter(siteName == "Backpack"), aes(x = longitude, y = latitude, label = siteName),
            nudge_x = 0.0005,
            nudge_y = -0.001,
            hjust = 0)

