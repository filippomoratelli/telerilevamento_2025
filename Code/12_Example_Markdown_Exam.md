# Exam project title: title

## Data gathering

Data were gathered from [Earth Observatory](https://earthobservatory.nasa.gov/).

### Packages used:
``` r
library(terra)
library(imageRy)
library(viridis) # in order to plot images with different viridis color palettes
```

### Setting the working directory and importing the images
``` r
setwd("~/Desktop/")
fires = rast("fires.jpg")
plot(fires)
fires = flip(fires)
plot(fires)
```

The image is the following:

![fires](https://github.com/user-attachments/assets/c647814a-673f-4ac0-9802-ea813fd55848)

## Data Analysis
Based on the data gathered from the site we can calculate and index using the first two bands:
``` r
fireindex = fires[[1]]-fires[[2]]
plot(fireindex)
```

In order to export the index we can use the png() function like:
``` r
png("fireindex.png")
plot(fireindex)
dev.off()
```

The index looks like:

![fireindex](https://github.com/user-attachments/assets/e199152f-cb59-4c90-aec1-6982cfc26b84)

## Index visualization by viridis
In order to visualize the index with another viridis palette we made use of the following code:

``` r
plot(fireindex, col=inferno(100))
```

The output will look like:

![inferno](https://github.com/user-attachments/assets/6a19c065-512f-406f-9f34-80dec3340fdc)
