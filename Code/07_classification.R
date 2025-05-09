    # classificare pixel in base a classi -> distanza spettrale di ogni pixel da ciascuna classe in un sistema a 3 assi

library(terra)
library(imageRy)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)
plot(mato1992)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

    # CLASSIFIED IMAGES
  # funzione im.classify(nome immagine, num classi, [seed=gruppo di pixel iniziale, serve per uniformare]) <- unsupervised classification (fa da solo)
mato1992c = im.classify(mato1992, num_clusters=2)
# due classi: una la foresta e l'altra ibrida (else)
# class 1 (yellow) = human (ELSE); class 2 (blue) = forest

mato2006c = im.classify(mato2006, num_clusters=2)
  # class 1 (yellow) = forest; class 2 (blue) = human (ELSE)

    # PERCENTUALI
  # prima calcolo frequenza
f1992 = freq(mato1992c)
f1992 # num pixel per classe
tot1992 = ncell(mato1992c)
tot1992
  # num pixel totali
prop1992 = f1992/tot1992
prop1992
  # proporzioni nella colonna count
perc1992 = prop1992 * 100
perc1992
  # human = 17%, forest = 83%

perc2006 = freq(mato2006c) * 100 / ncell(mato2006c)
perc2006
  # human = 55%, forest = 45%

    # CREARE DATAFRAME, si inizia specificando colonne
class = c("Forest", "Human")
y1992 = c(83, 17)
y2006 = c(45, 55)
tabout = data.frame(class, y1992, y2006)
tabout

  # GGPLOT(nome dataframe, aesthetics x y color) + geom_bar(stat, colore di fill)
library(ggplot2)
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white")
p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")

    # PATCHWORK unisce grafici fatti con ggplot
install.packages("patchwork")
library(patchwork)
p1 + p2
    # scale diverse -> aggiungo un argomento +ylim(c(0,100)) nelle due funzioni ggplot
p1 = ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 = ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p1 + p2
    # per avere colore riempimento = colore bordo metto fill=class nella sezione aes()

  # cosa carina ovvero mettere i 4 grafici insieme usando patchwork e imageRy (im.ggplot)
p0 = im.ggplot(mato1992)
p00 = im.ggplot(mato2006)
p0 + p00 + p1 + p2

  # altre disposizioni usando patchwork
p1 / p2 # uno sull'altro


# 3 aprile
        # Solar Orbiter
im.list()
solar = im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

    # EX: classifica immagine in 3 classi usando im.classify() e plotta insieme
solar_c = im.classify(solar, num_clusters=3)
im.multiframe(1,2)
plot(solar)
plot(solar_c)

    # rinomino le classi usando funzione subst
# 2 = low
# 3 = medium
# 1 = high

solar_c_s = subst(solar_c, c(2,3,1), c("c1_low","c2_medium","c3_high"))
plot(solar_c_s)

    # percentuali e dataframe
perc_solar = freq(solar_c_s)$count * 100 / ncell(solar_c_s)
        # high = 21%
        # medium = 41%
        # low = ~37%
class = c("c1_low","c2_medium","c3_high")
perc = c(38,41,21)
tabsol = data.frame(class, perc)

    # final ggplot
s1 = ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat="identity") # + ylim(c(0,100))
    # barre orizzontali invece che verticali si aggiunge coord_flip
ggplot(tabsol, aes(x=class, y=perc, fill=class, color=class)) + geom_bar(stat="identity") + coord_flip()
