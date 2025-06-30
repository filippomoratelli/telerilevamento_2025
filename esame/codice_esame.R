    # work directory
setwd("/Users/filippomoratelli/Desktop/UniBo/corsi/telerilevamento/esame")


    # pacchetti necessari
library(terra)
library(imageRy)
library(viridis)
library(ggridges)
library(patchwork)


    # importazione immagini
cortina_19 = rast("cortina_19.tif") # importo le immagini
cortina_25 = rast("cortina_25.tif")
im.multiframe(1,2) # creo un pannello multiframe per due immagini affiancate (in RGB)
plotRGB(cortina_19, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2019") # plotto le immagini
plotRGB(cortina_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2025")
dev.off() # chiudo


    # PNG da salvare
png("cortina_.png") # preparo il file png per salvare il plot
im.multiframe(2,2) # creo un secondo multiframe per visualizzare anche il suolo nudo con banda NIR al posto del blu
plotRGB(cortina_19, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2019 (RGB)")
plotRGB(cortina_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2025 (RGB)")
plotRGB(cortina_19, r = 1, g = 2, b = 4, stretch = "lin", main = "Cortina, 2019 (NIR)")
plotRGB(cortina_25, r = 1, g = 2, b = 4, stretch = "lin", main = "Cortina, 2025 (NIR)")
dev.off()


    # altre località - stesso procedimento
san_vito_19 = rast("san_vito_19.tif")
san_vito_25 = rast("san_vito_25.tif")
tai_19 = rast("tai_19.tif")
tai_25 = rast("tai_25.tif")

png("san_vito.png", width = 480, height = 620)    # cambio le dimensioni in quanto le immagini sono troppo alte e non appare il testo
im.multiframe(2,2)                 
plotRGB(san_vito_19, r = 1, g = 2, b = 3, stretch = "lin", main = "San Vito di Cadore, 2019 (RGB)")
plotRGB(san_vito_25, r = 1, g = 2, b = 3, stretch = "lin", main = "San Vito di Cadore, 2025 (RGB)")
plotRGB(san_vito_19, r = 1, g = 2, b = 4, stretch = "lin", main = "San Vito di Cadore, 2019 (NIR)")
plotRGB(san_vito_25, r = 1, g = 2, b = 4, stretch = "lin", main = "San Vito di Cadore, 2025 (NIR)")
dev.off()

png("tai.png")                      
im.multiframe(2,2)                 
plotRGB(tai_19, r = 1, g = 2, b = 3, stretch = "lin", main = "Tai di Cadore, 2019 (RGB)")
plotRGB(tai_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Tai di Cadore, 2025 (RGB)")
plotRGB(tai_19, r = 1, g = 2, b = 4, stretch = "lin", main = "Tai di Cadore, 2019 (NIR)")
plotRGB(tai_25, r = 1, g = 2, b = 4, stretch = "lin", main = "Tai di Cadore, 2025 (NIR)")
dev.off()


    # DVI e NDVI
dvi2019cortina = im.dvi(cortina_19, 4, 1) # calcolo il DVI (immagine, banda NIR, banda R)
dvi2025cortina = im.dvi(cortina_25, 4, 1)
ndvi2019cortina = im.ndvi(cortina_19, 4, 1) # calcolo il NDVI
ndvi2025cortina = im.ndvi(cortina_25, 4, 1)
png("cortina_dvi_ndvi.png")
im.multiframe(2,2)
plot(dvi2019cortina, main = "DVI Cortina, 2019")
plot(dvi2025cortina, main = "DVI Cortina, 2025")
plot(ndvi2019cortina, main = "NDVI Cortina, 2019")
plot(ndvi2025cortina, main = "NDVI Cortina, 2025")
dev.off()

ndvi2019sanvito = im.ndvi(san_vito_19, 4, 1)
ndvi2025sanvito = im.ndvi(san_vito_25, 4, 1)
ndvi2019tai = im.ndvi(tai_19, 4, 1)
ndvi2025tai = im.ndvi(tai_25, 4, 1)
png("sanvito_tai_ndvi.png")
im.multiframe(2,2)
plot(ndvi2019sanvito, main = "NDVI San Vito, 2019", col=viridis(100))
plot(ndvi2025sanvito, main = "NDVI San Vito, 2025", col=viridis(100))
plot(ndvi2019tai, main = "NDVI Tai, 2019", col=viridis(100))
plot(ndvi2025tai, main = "NDVI Tai, 2025",col=viridis(100))
dev.off()


    # analisi multitemporale
cortina_diff = cortina_19[[2]] - cortina_25[[2]]        # calcolo differenza nella banda del verde tra 2019 e 2025
plot(cortina_diff, main = "Cortina 2019-2025: differenza nella banda del verde")

cortina_diff_ndvi = ndvi2019cortina - ndvi2025cortina   # calcolo differenza NDVI
plot(cortina_diff_ndvi, main = "Cortina 2019-2025: differenza di NDVI")

png("cortina_diff.png")                                # creo png con multiframe verde + NDVI
im.multiframe(1,2)
plot(cortina_diff, main = "Cortina 2019-2025:\ndifferenza banda del verde")
plot(cortina_diff_ndvi, main = "Cortina 2019-2025:\ndifferenza NDVI")
dev.off()

san_vito_diff_ndvi = ndvi2019sanvito - ndvi2025sanvito    # ripeto (solo ndvi) per le altre località
tai_diff_ndvi = ndvi2019tai - ndvi2025tai
png("cadore_diff.png")
im.multiframe(1,2)
plot(san_vito_diff_ndvi, main = "San Vito 2019-2025:\ndifferenza NDVI")
plot(tai_diff_ndvi, main = "Tai 2019-2025:\ndifferenza NDVI")
dev.off()


        # crop immagini Cortina per maggior accuratezza (solo pista da bob) usando la funzione draw di terra
plotRGB(cortina_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2025 (RGB)")    # plotto l'immagine da croppare
crop_cortina = draw(x="extent", col="red", lwd=2)            # disegno un rettangolo sopra l'area di interesse
cortina_25_crop = crop(cortina_25, crop_cortina)             # applico il crop alle due immagini originali e a quelle di ndvi
cortina_19_crop = crop(cortina_19, crop_cortina)
ndvi_19crop = crop(ndvi2019cortina, crop_cortina)
ndvi_25crop = crop(ndvi2025cortina, crop_cortina)
png("pistabob.png")
im.multiframe(2,2)
plotRGB(cortina_19_crop, r = 1, g = 2, b = 3, stretch = "lin", main = "Pista da bob, 2019")
plotRGB(cortina_25_crop, r = 1, g = 2, b = 3, stretch = "lin", main = "Pista da bob, 2025")
plot(ndvi_19crop, main = "NDVI pista da bob, 2019")
plot(ndvi_25crop, main = "NDVI pista da bob, 2025")
dev.off()


        # ridgeline delle immagini ndvi croppate pista da bob
cortina_rl = c(ndvi_19crop, ndvi_25crop)                 # costruisco vettore con elementi le due immagini croppate ndvi
names(cortina_rl) =c("NDVI 2019", "NDVI 2025")           
png("ridgeline_bob.png")
im.ridgeline(cortina_rl, scale=1, palette="viridis")
dev.off()


        # classificazione immagini
cortina_19_class = im.classify(ndvi_19crop, num_clusters=2)            # divido i pixel di ogni immagine in due cluster a seconda dei valori
cortina_25_class = im.classify(ndvi_25crop, num_clusters=2)
png("classi_ndvi.png")                                                 # plotto le immagini con i pixel suddivisi nei due cluster per vedere come sono stati classificati
im.multiframe(1,2)
plot(cortina_19_class, main = "Pixel NDVI pista da bob, 2019")
plot(cortina_25_class, main = "Pixel NDVI pista da bob, 2025")
dev.off()
perc_19_c = freq(cortina_19_class) * 100 / ncell(cortina_19_class)     # calcolo la frequenza percentuale di ciascun cluster
perc_19_c                                                              # visualizzo la frequenza percentuale
          layer     value    count
    1 0.0192604 0.0192604 28.21649
    2 0.0192604 0.0385208 71.78351
perc_25_c = freq(cortina_25_class) * 100 / ncell(cortina_25_class)
perc_25_c                                                               
          layer     value count
    1 0.0192604 0.0192604  37.5
    2 0.0192604 0.0385208  62.5
NDVI = c("elevato", "basso")                                            # creo vettore con i nomi dei due cluster (valori elevati e bassi di NDVI)
anno_2019 = c(71.8, 28.2)                                               # creo vettore con le percentuali per ciascun anno
anno_2025 = c(62.5, 37.5)
tabout = data.frame(NDVI, anno_2019, anno_2025)                        # creo dataframe con i valori di ndvi per anno e lo visualizzo
tabout
         NDVI anno_2019 anno_2025
    1 elevato      71.8      62.5
    2   basso      28.2      37.5
ggplotcortina19 = ggplot(tabout, aes(x=NDVI, y=anno_2019, fill=NDVI, color=NDVI))+geom_bar(stat="identity")+ylim(c(0,100))    # creo ggplot per ogni anno
ggplotcortina25 = ggplot(tabout, aes(x=NDVI, y=anno_2025, fill=NDVI, color=NDVI))+geom_bar(stat="identity")+ylim(c(0,100))
png("ggplot_ndvi.png")
ggplotcortina19 + ggplotcortina25 + plot_annotation(title = "Valori NDVI (% superficie) nel sito della pista da bob di Cortina")    # creo grafico con entrambi i ggplot creati
dev.off()

