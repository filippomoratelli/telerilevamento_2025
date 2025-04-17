# R code for Principal Component Analysis

library(imageRy)
library(terra

im.list()

sent = im.import("sentinel.png")
sent = flip(sent)
plot(sent)

  # nuovo oggetto con 3 layer in ordine specifico (NIR, r, g) -> importante per PCA
sent = c(sent[[1]],sent[[2]],sent[[3]])
  # bande in colonne, ogni colonna ha un significato
  # NIR = band 1
  # red = band 2
  # green = band 3

sentpca = im.pca(sent, n_samples=100000)

  # tot = 72 + 59 + 6
  # 137
