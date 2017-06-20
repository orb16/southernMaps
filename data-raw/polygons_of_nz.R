require(maps)
require(mapdata)
require(sp)
require(ggplot2)
require(rgeos)
require(rgdal)

setwd("~/Documents/southernMaps/")

dfmap <- readOGR(dsn = "data-raw/lds-nz-coastlines-and-islands-polygons-topo-1500k-SHP",
                 layer = "nz-coastlines-and-islands-polygons-topo-1500k")


detailed_islands <- readOGR("data-raw/lds-nz-coastlines-and-islands-polygons-topo-150k-SHP",
                            layer = "nz-coastlines-and-islands-polygons-topo-150k")


dfmap_smaller <- dfmap[dfmap@data$name %in% c(
  "Stewart Island/Rakiura",
  "South Island or Te Waipounamu",
  "North Island or Te Ika-a-Māui"
),
]




# relatively high level
nzHigh <- SpatialPolygonsDataFrame(gSimplify(dfmap_smaller, 300, topologyPreserve = TRUE), dfmap_smaller@data)
nzMed <- SpatialPolygonsDataFrame(gSimplify(dfmap_smaller, 500, topologyPreserve = TRUE), dfmap_smaller@data)
nzSml <- SpatialPolygonsDataFrame(gSimplify(dfmap_smaller, 2000, topologyPreserve = TRUE), dfmap_smaller@data)

wgs84 <- CRS("+init=epsg:3857 +proj=longlat ")

nzHigh84 <- spTransform(nzHigh, wgs84)
nzMed84 <- spTransform(nzMed, wgs84)
nzSml84 <- spTransform(nzSml, wgs84)


devtools::use_data(nzHigh, overwrite = TRUE)
devtools::use_data(nzMed, overwrite = TRUE)
devtools::use_data(nzSml, overwrite = TRUE)

devtools::use_data(nzHigh84, overwrite = TRUE)
devtools::use_data(nzMed84, overwrite = TRUE)
devtools::use_data(nzSml84, overwrite = TRUE)

# whoel thing
detailed_nz_islands <- detailed_islands
devtools::use_data(detailed_nz_islands, overwrite = TRUE)
epsg_table <- make_EPSG()
devtools::use_data(epsg_table)




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
