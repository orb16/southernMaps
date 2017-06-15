# southernMaps

Package of maps (for NZ) and assorted functions. The data include the following maps as SpatialPolygonsDataFrames:

1. nzHigh (high res), nzMed, nzSml (low res) in NZTM
2. nzHigh84, nzMed84, nzSml84 as above, but in WGS84.

install as follows (you'll need devtools installed (`install.packages('devtools')`))

```{r}
devtools::install_github("orb16/southernMaps")
require(southernMaps)
```

examples:

```{r}

# whole country 

par(mfrow = c(1, 3))
plot(nzHigh, main = "nzHigh", border = "red2")
plot(nzMed, main = "nzMed, col = "orange")
plot(nzSml, main = "nzSml")
par(mfrow = c(1, 1))

par(mfrow = c(1, 3))
plot(nzHigh[nzHigh@data$name == "Stewart Island/Rakiura", ], main = "nzHigh: Stewart Island")
plot(nzMed[nzMed@data$name == "Stewart Island/Rakiura", ], main = "nzMed: Stewart Island")
plot(nzSml[nzSml@data$name == "Stewart Island/Rakiura", ], main = "nzSml: Stewart Island")
par(mfrow = c(1, 1))


```