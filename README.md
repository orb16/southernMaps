# southernMaps <img src='man/figures/logo.png' align="right" height="139" />

[![DOI](https://zenodo.org/badge/94381659.svg)](https://zenodo.org/badge/latestdoi/94381659)

Package of maps (for NZ) and assorted functions. Why? The map('nzHires') doesn't work with all WGS84 point data (you can end up in the ocean for surprisingly terrestrial points), and when you convert the LINZ map of NZ in WGS84, they don't line up:

![bad maps](map_differences.png)

The data include the following maps as SpatialPolygonsDataFrames:

1. nzHigh (high res), nzMed, nzSml (low res) in NZTM
2. nzHigh84, nzMed84, nzSml84 as above, but in WGS84.

install as follows (you'll need devtools installed (`install.packages('devtools')`))

```{r}
# devtools::install_github("orb16/southernMaps")
# update
# to get the vignette to build, use the code below
devtools::install_github("orb16/southernMaps", build_opts = c("--no-resave-data", "--no-manual"))
require(southernMaps)

# if this errors because of a dependency issue ("error converted from warning")
# try this instead:

Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS="true")
devtools::install_github("orb16/southernMaps", build_opts = c("--no-resave-data", "--no-manual"))
# might as well restart R here, then load pacakge
require(southernMaps)

```

**new:** now with vignette! After loading the package run `vignette("southernMaps-Vignette")` in R to read it! Read on for some basic examples too. Note that now all the objects are *sf*, to plot a plain map, you need to just do `r st_geometry(objectname)` or `r objectname %>% st_geometry()` to plot it as you would expect from a SpatialPolygonsDataFrame (old style).

examples:

```{r}

# whole country 

par(mfrow = c(1, 3))
plot(nzHigh %>% st_geometry(), main = "nzHigh", border = "red2")
plot(nzMed %>% st_geometry(), main = "nzMed", col = "grey", border = NA)
plot(nzSml %>% st_geometry(), main = "nzSml")
par(mfrow = c(1, 1))

# Stewart Island - shows difference in resolution 

par(mfrow = c(1, 3))
plot(nzHigh %>% filter(name == "Stewart Island/Rakiura") %>% st_geometry(), main = "nzHigh: Stewart Island")
plot(nzMed %>% filter(name == "Stewart Island/Rakiura") %>% st_geometry(), main = "nzMed: Stewart Island")
plot(nzSml %>% filter(name == "Stewart Island/Rakiura") %>% st_geometry(), main = "nzSml: Stewart Island")
par(mfrow = c(1, 1))

# get CRS for NZTM
We used to have a function for this but under sf package it's somewhat superceded. Just google "epsg" and the projection you want (e.g. NZTM) and you can then use it with `r st_crs()`

# e.g. for NZTM
st_crs(2193)

# get high res version of small islands:

isle <- find_my_island("chatham", "wgs84")
plot(isle)
plot(st_geometry(isle), main = "Chatham Islands")

# or in NZTM:

isle <- find_my_island("chatham", "nztm")
plot(isle %>% st_geometry(), main = "Chatham Islands")

```
