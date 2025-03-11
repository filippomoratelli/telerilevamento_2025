# Code to calculate spectral indices from satellite images

library(imageRy)
library(terra)
library(viridis)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
# bands: 1 = NIR, 2 = red, 3 = green

# we need to flip it
mato1992 = flip(mato1992)
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1) # non vegetation (bare soil) becomes yellow

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
im.plotRGB(mato2006, r=2, g=3, b=1)

im.multiframe(1,2)
im.plotRGB(mato1992, r=2, g=3, b=1, title = "Mato Grosso, 1992")
im.plotRGB(mato2006, r=2, g=3, b=1, title = "Mato Grosso, 2006")

# Radiometric resolution
plot(mato1992[[1]], col=inferno(100))
plot(mato2006[[1]], col=inferno(100))
# values go from 0 to 255, why 255? images at 8 bits = 256 possible values (2^8)

# DVI
# Healthy tree: NIR=255, red=0, DVI = NIR-red = 255
# Stressed tree: NIR = 100, red = 20, DVI = 80
