# R code for visualizing satellite data

library(terra)
library(imageRy)

im.list()

# for the whole course we are going to make us of = instead of <-
b2 = im.import("sentinel.dolomites.b2.tif")
cl = colorRampPalette(c("black", "dark grey", "light grey"))(100)
plot(b2, col=cl)
