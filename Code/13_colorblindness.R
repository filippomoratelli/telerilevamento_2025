# Code to solve colorblindness problems

# Packages
library(terra)
library(cblindplot)
library(imageRy)

    # importing data
    # Vinicunca
setwd("~/Desktop/")
vinicunca = rast("vinicunca.jpg")
plot(vinicunca)
vinicunca = flip(vinicunca)
plot(vinicunca)

  # Simulating colorblindness
im.multiframe(1,2)
im.plotRGB(vinicunca, r=1, g=2, b=3, title="Standard vision")
im.plotRGB(vinicunca, r=2, g=1, b=3, title="Protanopia")
dev.off()

    # Solving colorblindess
rainbow = rast("rainbow.jpg")
plot(rainbow)
rainbow = flip(rainbow)
plot(rainbow)
    # uso la funzione cblind.plot(immagine, tipo malattia cvd "color vision deficiency")
cblind.plot(rainbow, cvd= "protanopia")
cblind.plot(rainbow, cvd= "deuteranopia")
cblind.plot(rainbow, cvd= "tritanopia")
