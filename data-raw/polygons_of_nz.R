require(maps)
require(mapdata)
require(sp)
require(dplyr)
require(usethis)
require(ggplot2)
require(rgeos)
require(rgdal)
require(rmapshaper)

setwd("~/Documents/southernMaps/")

dfmap <- st_read(dsn = "data-raw/lds-nz-coastlines-and-islands-polygons-topo-1500k-SHP",
                 layer = "nz-coastlines-and-islands-polygons-topo-1500k")


detailed_islands <- st_read("data-raw/lds-nz-coastlines-and-islands-polygons-topo-150k-SHP",
                            layer = "nz-coastlines-and-islands-polygons-topo-150k")


dfmap_smaller <- dfmap %>%
  filter(name %in% c(
    "Stewart Island/Rakiura",
    "South Island or Te Waipounamu"
  ) | grepl("or Te Ika", name))


dfmap_smaller2 <- dfmap %>%
  st_crop(st_bbox(dfmap_smaller)) %>%
  dplyr::mutate(area = as.numeric(st_area(.))) %>%
  dplyr::filter(area >= 80000000)


# relatively high level
spat <- as_Spatial(dfmap_smaller)
nzHigh <- ms_simplify(dfmap_smaller2, 0.13)
nzHighOld <- SpatialPolygonsDataFrame(gSimplify(spat, 300, topologyPreserve = TRUE),
                                      spat@data)

par(mfrow = c(1,2))
plot(nzHigh %>% st_geometry())
plot(nzHighOld)


nzMed <- ms_simplify(dfmap_smaller2, 0.07)
nzMedOld <- SpatialPolygonsDataFrame(gSimplify(spat, 500, topologyPreserve = TRUE),
                                     spat@data)

mapview::npts(nzMed)
mapview::npts(st_as_sf(nzMedOld))

par(mfrow = c(1,2))
plot(nzMed %>% st_geometry())
plot(nzMedOld)


nzSml <- ms_simplify(dfmap_smaller2, 0.03)
nzSmlOld <- SpatialPolygonsDataFrame(gSimplify(spat, 2000, topologyPreserve = TRUE),
                                     spat@data)

mapview::npts(nzSml)
mapview::npts(st_as_sf(nzSmlOld))

par(mfrow = c(1,2))
plot(nzSml %>% st_geometry(),main = "New")
plot(nzSmlOld, main = "Old")



wgs84 <- st_crs("EPSG:4326")

nzHigh84 <- nzHigh %>% st_transform(., wgs84)
nzMed84 <- nzMed %>% st_transform(., wgs84)
nzSml84 <- nzSml %>% st_transform(., wgs84)


usethis::use_data(nzHigh, overwrite = TRUE)
usethis::use_data(nzMed, overwrite = TRUE)
usethis::use_data(nzSml, overwrite = TRUE)

usethis::use_data(nzHigh84, overwrite = TRUE)
usethis::use_data(nzMed84, overwrite = TRUE)
usethis::use_data(nzSml84, overwrite = TRUE)


# whoel thing
detailed_nz_islands <- detailed_islands
usethis::use_data(detailed_nz_islands, overwrite = TRUE)
epsg_table <- make_EPSG()
usethis::use_data(epsg_table)




par(mfrow = c(1, 3))
plot(nzHigh, main = "nzHigh")
plot(nzMed, main = "nzMed")
plot(nzSml, main = "nzSml")
par(mfrow = c(1, 1))

par(mfrow = c(1, 3))
plot(nzHigh[nzHigh@data$name == "Stewart Island/Rakiura", ], main = "nzHigh: Stewart Island")
plot(nzMed[nzMed@data$name == "Stewart Island/Rakiura", ], main = "nzMed: Stewart Island")
plot(nzSml[nzSml@data$name == "Stewart Island/Rakiura", ], main = "nzSml: Stewart Island")
par(mfrow = c(1, 1))
#
# nicer_nztm <- broom::tidy(dfmap_smaller_simplif3)
# nice_nztm <- broom::tidy(dfmap_smaller_simplif2)
#
#
# nzmap_wgs84 <- spTransform(nzSml, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "))
#
# nzmap_nzgd <- spTransform(nzSml, CRS("+proj=longlat +ellps=intl +datum=nzgd49 +no_defs "))
#
# nzpkg <- map_data("nz")
# nzpkg2 <- nzpkg
# coordinates(nzpkg2) <- ~ long + lat
# proj4string(nzpkg2) <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
#
# thegroups <- unique(nzpkg2$group)
# polylist <- list()
# for(groups in seq_along(thegroups)){
# 	polylist[[groups]] <- Polygon(nzpkg2[nzpkg2$group == groups,])
# }
# tm <- Polygons(polylist, "ID")
# tm2 <- SpatialPolygons(tm, proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
#
#
# buildings_list <- split(nzpkg2, nzpkg2$group)
#
# ps <- lapply(buildings_list, Polygon)
#
# # add id variable
# p1 <- lapply(seq_along(ps), function(i) Polygons(list(ps[[i]]),
#                                             ID = names(buildings_list)[i]  ))
#
# # create SpatialPolygons object
# my_spatial_polys <- SpatialPolygons(p1, proj4string = CRS("+proj=longlat +datum=WGS84") )
#
#
#
# nzpkg4 <- SpatialPolygonsDataFrame(my_spatial_polys,
#                                    data.frame(group = unique(nzpkg2$group)))
#
#
# png(file = "map_differences.png", width = 210, height = 297, units = "mm", res = 400)
# plot(nzpkg4, main = "Difference between map('NZ') and LINZ NZ map data")
# plot(nzmap_wgs84, border = "cornflowerblue", add = TRUE)
# dev.off()
#
#
#
# nzpkg_nztm <- spTransform(nzpkg4,  dfmap_smaller_simplif2@proj4string)
#
# plot(nzpkg_nztm)
# plot(dfmap_smaller_simplif2, border = "red2", add = TRUE)
