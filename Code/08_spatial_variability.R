# Code for calculating spacial variability

    # STANDARD DEVIATION
# dataset con 4 età
23, 22, 23, 49
  # MEDIA
m = (23 + 22 + 23 + 49) / 4
# m = 29.25
  # SCARTO QUADRATICO (numeratore)
sq = (23-m)^2 + (22-m)^2 + (23-m)^2 + (49-m)^2
# sq = 521
  # VARIANZA (sq/n dati)
var = sq / 4
# var = 130.25
stdev = sqrt(var)
# stdev = 11.40997




library(terra)
library(imageRy)
library(ggplot2)
library(viridis)
library(patchwork)

sent = im.import("sentinel.png")
	# band 1 = NIR
	# band 2 = red
	# band 3 = green
sent = flip(sent)
    # EXERCISE: plot the image in RGB with the NIR ontop of the red component
im.plotRGB(sent, 1,2,3)

nir = sent[[1]]
plot(nir)
    # EXERCISE: plot the nir band with the inferno color ramp palette
        plot(nir, col=inferno(100))

    # funzione focal (elemento, dimensioni finestra mobile, funzione)
sd3 = focal(nir, w=c(3,3), fun=sd)
plot(sd3)
            # prof usa funzione diversa per dimensioni (crea matrice)

im.multiframe(1,2)
im.plotRGB(sent, 1,2,3)
plot(sd3)

        # EXERCISE calculate sd of the nir band with a moving window of 5 pixels
    sd5 = focal(nir, w=c(5,5), fun=sd)
    im.multiframe(1,2)
    plot(sd3)
    plot(sd5)

        # EXERCISE use ggplot to plot the sd
    im.ggplot(sd3)
        # EXERCISE plot the two sd maps (3 and 5) one beside the other with ggplot
    p1 = im.ggplot(sd5)
    p2 = im.ggplot(sd5)
    p1+p2

        # EXERCISE with ggplot plot the original set in RGB (ggRGB, pacchetto RStoolbox) together with the sd3 and 5
install.packages("RStoolbox")
library(RStoolbox)
        p3 = ggRGB(sent, r=1, g=2, b=3)   
        p3 + p1 + p2
