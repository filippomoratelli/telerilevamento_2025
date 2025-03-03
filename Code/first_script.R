# First R coding from scratch

2 + 3

anna <- 2 + 3 # assign an operation to an object
chiara <- 4 + 6

anna + chiara

filippo <- c(0.2, 0.4, 0.6, 0.8, 0.9) # array, biomassa lattuga (NDVI)
luca <- c(100, 80, 60, 50, 10) # quantità rifiuti in ppm

plot(luca, filippo) # grafico
plot(luca, filippo, pch=19, col="blue", cex=2, xlab="rubbish", ylab="biomass")

# INSTALLING PACKAGES
# CRAN
install.packages("terra")
install.packages("devtools")
library(devtools)
install_github("ducciorocchini/imageRy")

# Rtools 4.4
# update packages: avoid just press enter
3
im.list()
