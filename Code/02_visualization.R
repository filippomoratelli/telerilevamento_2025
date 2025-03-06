# R code for visualizing satellite data

library(terra)
library(imageRy)

im.list()

# for the whole course we are going to make us of = instead of <-
# sentinel bands https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/bands/

# band 2 (blue)
b2 = im.import("sentinel.dolomites.b2.tif")

# new color palette
cl = colorRampPalette(c("black", "dark grey", "light grey"))(100) # three colors + n shades between them
plot(b2, col=cl)

# band 3 (green)
b3 = im.import("sentinel.dolomites.b3.tif")

# band 4 (red)
b4 = im.import("sentinel.dolomites.b4.tif")

# band 8 (NIR, near infrared)
b8 = im.import("sentinel.dolomites.b8.tif")

# plot all bands together (old option)
par(mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# close plot panel
dev.off()

# other way
im.multiframe(1,4)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# plot stacked one on top of the other (4 row, 1 column, VERTICAL)
im.multiframe(4,1)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# black and white, new color palette
cl=colorRampPalette(c("black", "light grey"))(100)
im.multiframe(2,2)
plot(b2, col=cl)
plot(b4, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

# stack
sent = c(b2, b3, b4, b8)
names(sent) = c("b2-blue", "b3-green", "b4-red", "b8-NIR") # to change names
plot(sent, col=cl)

# plot only one element
plot(sent$"b8-NIR") # or I remove the - symbol and call them b8NIR
# or
plot(sent[[4]]) # to plot the fourth element

# importing several bands altogether
sentdol = im.import("sentinel.dolomites")

# importing several sets altogether
pairs(sentdol)
