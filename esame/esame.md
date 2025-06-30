> ### Filippo Moratelli
>> #### matricola n. 1007077

# L'impatto ambientale dei XXV Giochi Olimpici Invernali sulla Valle del Boite (BL) 🏔️

In questo lavoro è stato analizzato tramite telerilevamento satellitare l'impatto sulla copertura vegetale di alcune opere relative ai **XXV Giochi Olimpici Invernali**, previsti a Milano, Cortina d'Ampezzo e altre località delle Alpi Italiane per il febbraio 2026.

Nel dettaglio, è stata confrontata la situazione **tra il 2019 e il 2025** in alcune località situate in **Valle del Boite** (provincia di Belluno) interessate da opere direttamente o indirettamente connesse alle Olimpiadi, ovvero:
+ **Cortina d'Ampezzo**, sede dei Giochi, presso cui sono recentemente terminati i lavori per l'ammodernamento della **Pista Olimpica *"Eugenio Monti"*** dove si terranno le discipline di bob, slittino e skeleton;
+ **San Vito di Cadore**, dove sono in corso i lavori per la costruzione di una **variante stradale** alla Strada statale 51 di Alemagna che permetta di alleggerire il traffico all'interno del centro cittadino;
+ **Tai di Cadore**, dove sempre per la SS51 è in costruzione una **galleria stradale** a sud dell'abitato in modo da evitarne l'attraversamento.

![esame_telerilev](https://github.com/user-attachments/assets/147f6c3b-46e0-437e-b012-b8cda0b99198)
*Le tre aree analizzate dallo studio e la loro collocazione all'interno della Regione Veneto*


## Raccolta delle immagini 🛰️
### Download delle immagini
Le immagini satellitari utilizzate provengono dalla missione **ESA Sentinel-2** e sono state ottenute tramite la piattaforma di **Google Earth Engine**, permettendo quindi di avere accesso anche alle immagini più recenti e aggiornate possibili (giugno 2025).

Come anno base di riferimento è stato scelto il **2019**, anno di assegnazione dei Giochi Olimpici a Milano e Cortina e quindi precedente all'inizio di qualsiasi lavoro effettivamente collegato alle Olimpiadi; il 2019 è inoltre successivo alla tempesta Vaia, permettendo quindi di escludere dall'analisi eventuali variazioni nella copertura arborea dovute ai danni da vento.  
Come stagione è stata scelta per entrambi gli anni la tarda primavera (**dal 1° maggio al 30 giugno**), periodo in cui le piante sono appena rientrate in piena attività fotosintetica anche alle altitudini dello studio (ovvero tra gli 800 e i 1500 m slm).

Per ogni area di studio sono state scaricate **2 immagini diverse** (una per il 2019 e una per il 2025, con bande RGB e NIR). Le immagini sono la **mediana composita** tra le varie immagini disponibili per ciascun periodo indicato tenendo conto anche dei **filtri sulla copertura nuvolosa** (solo immagini con meno del 20% di nuvole).

``` JavaScript
// creazione rettangolo sull'area di Cortina
var cortina = 
    ee.Geometry.Polygon(
      [[[12.104618443814838, 46.556871547419085],
        [12.104618443814838, 46.53367168301251],
        [12.145302190152728, 46.53367168301251],
        [12.145302190152728, 46.556871547419085]]], null, false);
// esportazione in GDrive di file GeoJSON del poligono per creare una mappa di riferimento tramite QGis    
Export.table.toDrive({          
  collection: ee.FeatureCollection(ee.Feature(cortina)),
  description: 'export_cortina_aoi',
  folder: 'GEE_exports',
  fileFormat: 'GeoJSON'
});

function maskS2clouds(image) {       // per mascherare le nuvole usando la banda QA60
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;        // nuvole opache
  var cirrusBitMask = 1 << 11;       // cirri
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));    // per tenere solo i pixel in cui nuvole e cirri siano 0
  return image.updateMask(mask).divide(10000);    // maschera nuvole e valori di riflettanza scalati (0–10000 ➝ 0–1)
}

// preparazione della collezione di immagini
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(cortina)                               // area di interesse = poligono cortina
                   .filterDate('2019-05-01', '2019-06-30')              // date iniziali
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20)) // solo immagini con copertura nuvolosa <20%
                   .map(maskS2clouds);                                  // maschera nuvole
// visualizzazione numero di immagini disponibili dopo applicazione dei filtri
print('Number of images in collection:', collection.size());

// creazione di un'immagine mediana composta a partire dalla collezione
var composite = collection.median().clip(cortina);

// visualizzazione sulla mappa dell'immagine appena creata
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');

// esportazione dell'immagine in GDrive (con bande red, green, blue, NIR)
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2', 'B8']),  // selezione bande
  description: 'cortina_19',
  folder: 'GEE_exports',                        // nome cartella in GDrive
  fileNamePrefix: 'cortina_19',                 // nome file
  region: cortina,                              // area di interesse
  scale: 10,                                    // risoluzione di Sentinel-2 (10 km)
  crs: 'EPSG:32632',                            // sistema di riferimento per l'Italia
  maxPixels: 1e13
});
```
Questo codice è stato poi riutilizzato con le **date relative al 2025** (2025-05-01, 2025-06-30) per la creazione e il download della seconda immagine composita aggiornata.

Il processo è stato poi **ripetuto per le altre due località** dello studio.

``` JavaScript
// rettangolo per l'area di San Vito di Cadore
var san_vito =
    ee.Geometry.Polygon(
      [[[12.193006447322698, 46.471473706914416],
        [12.193006447322698, 46.447113727544775],
        [12.223905495174261, 46.447113727544775],
        [12.223905495174261, 46.471473706914416]]], null, false);

// rettangolo per l'area di Tai di Cadore
var tai = 
    ee.Geometry.Polygon(
      [[[12.339676841100946, 46.432599317650634],
        [12.339676841100946, 46.41271956415987],
        [12.376927359899774, 46.41271956415987],
        [12.376927359899774, 46.432599317650634]]], null, false);
```

### Importazione e visualizzazione delle immagini in R - Cortina d'Ampezzo
Le immagini (in formato .tif) sono state poi scaricate da Google Drive, trasferite in una cartella apposita e successivamente ricaricate in **R** tramite il **pacchetto terra** per l'analisi.

I pacchetti utilizzati durante l'importazione e l'analisi delle immagini in R sono quindi stati:
+ **terra**, per l'importazione delle immagini in formato .tif;
+ **imageRy**, per la visualizzazione (plot) delle immagini con più bande;
+ **viridis**, per le palette di colori;
+ **ggridges**, per la creazione di plot ridgeline;
+ **ggplot2**, per la creazione di grafici a barre;
+ **patchwork**, per l'unione dei grafici creati con ggplot2.
  
È stata poi fatta una prima analisi per confrontare l'area di Cortina d'Ampezzo tra il 2019 e il 2025 con i **colori reali** (bande RGB) e visualizzando il suolo nudo utilizzando la banda del **vicino infrarosso** al posto della banda blu.

``` R
setwd("/Users/filippomoratelli/Desktop/UniBo/corsi/telerilevamento/esame") # imposto la work directory

library(terra)                            # carico tutti i pacchetti necessari
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

cortina_19 = rast("cortina_19.tif")       # importo le immagini
cortina_25 = rast("cortina_25.tif")
im.multiframe(1,2)                        # creo un pannello multiframe per due immagini affiancate (in RGB)
plotRGB(cortina_19, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2019") # plotto le immagini
plotRGB(cortina_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2025")
dev.off()                                 # chiudo

png("cortina.png")                       # preparo il file png per salvare il plot
im.multiframe(2,2)                        # creo un secondo multiframe per visualizzare anche il suolo nudo con banda NIR al posto del blu
plotRGB(cortina_19, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2019 (RGB)")
plotRGB(cortina_25, r = 1, g = 2, b = 3, stretch = "lin", main = "Cortina, 2025 (RGB)")
plotRGB(cortina_19, r = 1, g = 2, b = 4, stretch = "lin", main = "Cortina, 2019 (NIR)")
plotRGB(cortina_25, r = 1, g = 2, b = 4, stretch = "lin", main = "Cortina, 2025 (NIR)")
dev.off()
```

![cortina](https://github.com/user-attachments/assets/fa1c32f3-dbbf-4c49-9cb0-1c9b67e8e21f)

*Le quattro immagini di confronto per l'area di Cortina d'Ampezzo, in colori reali (RGB) e usando la banda del vicino infrarosso per evidenziare il suolo nudo (in giallo) rispetto alla copertura vegetale (in blu).  
Si nota l'area della pista da bob al centro delle immagini del 2025, in località Ronco, e le piste da sci del Col Drusciè sulla sinistra.*

### Importazione e visualizzazione delle immagini in R - San Vito e Tai di Cadore
Lo stesso procedimento, con gli stessi codici, è stato poi ripetuto per le immagini delle altre due località interessate dallo studio.

![san_vito](https://github.com/user-attachments/assets/1a81cef1-6661-46e4-87ad-27f71c13d47a)

*Nelle immagini si nota il cantiere per la costruzione della variante della SS51 ad ovest del centro abitato di San Vito di Cadore, parallela al torrente Boite.*

![tai](https://github.com/user-attachments/assets/597c5426-4f4f-4636-9563-eb4220cf3b77)

*In queste immagini si può notare, a sud dell'abitato di Tai di Cadore, l'impatto della costruzione della galleria dell'altra variante della SS51 e delle opere annesse.*



## Analisi delle immagini - Cortina d'Ampezzo 🛷
### Indici spettrali
Si è poi proceduto a visualizzare le variazioni di **DVI** (Difference Vegetation Index) e **NDVI** (Normalized Difference Vegetation Index), che calcolano la differenza tra la banda del vicino infrarosso e quella del rosso per valutare lo stato di salute (o, in questo caso, la presenza) delle piante. L'NDVI viene normalizzato (valori tra -1 e +1) calcolando anche il rapporto tra differenza e somma di NIR e Red.

``` R
dvi2019cortina = im.dvi(cortina_19, 4, 1)     # calcolo il DVI (immagine, banda NIR, banda R)
dvi2025cortina = im.dvi(cortina_25, 4, 1)
ndvi2019cortina = im.ndvi(cortina_19, 4, 1)   # calcolo il NDVI
ndvi2025cortina = im.ndvi(cortina_25, 4, 1)

png("cortina_dvi_ndvi.png")                   # preparo il file per salvare il plot
im.multiframe(2,2)                            # creo un multiframe dove plottare le 4 immagini
plot(dvi2019cortina, main = "DVI Cortina, 2019")
plot(dvi2025cortina, main = "DVI Cortina, 2025")
plot(ndvi2019cortina, main = "NDVI Cortina, 2019")
plot(ndvi2025cortina, main = "NDVI Cortina, 2025")
dev.off()
```

![cortina_dvi_ndvi](https://github.com/user-attachments/assets/390bd820-9474-484c-aa5a-4ff91b63955b)

*Più il valore tende al giallo più le piante sono fotosinteticamente attive, mentre il blu scuro rappresenta zone con bassa attività fotosintetica (acqua, roccia nuda, strade, edifici e cantieri).*

### Analisi multitemporale
Per visualizzare meglio l'impatto dei lavori per la pista da bob è stata calcolata la **differenza tra le immagini del 2019 e del 2025** per quanto riguarda la **banda del rosso** e i valori di **NDVI**.

``` R
cortina_diff = cortina_19[[1]] - cortina_25[[1]]        # calcolo differenza nella banda del rosso tra 2019 e 2025
cortina_diff_ndvi = ndvi2019cortina - ndvi2025cortina   # calcolo differenza NDVI

png("cortina_diff.png")
im.multiframe(1,2)                                      # plotto le due immagini insieme
plot(cortina_diff, main = "Cortina 2019-2025:\ndifferenza banda del rosso")
plot(cortina_diff_ndvi, main = "Cortina 2019-2025:\ndifferenza NDVI")
dev.off()
```

![cortina_diff](https://github.com/user-attachments/assets/c7bd21cf-90e9-45ee-ba0b-115d55d6e6dd)


*In entrambe le immagini è ben visibile una "macchia" di colore diverso al centro dell'immagine in corrispondenza della pista da bob, dove i lavori hanno infatti comportato l'abbattimento di numerosi alberi, principalmente larici e abeti.*

Tramite la **funzione draw** del pacchetto terra si sono poi croppate le immagini sul **sito della pista da bob** per valutare più accuratamente le variazioni temporali nel sito specifico dove l'impatto è maggiore.

``` R
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
```

![pistabob](https://github.com/user-attachments/assets/faefe798-db24-4e71-a457-b7f936acd65b)

*Le immagini originali RGB e NDVI di Cortina ingrandite sulla sola zona della pista da bob.*

Per visualizzare graficamente la frequenza dei pixel di ogni immagine per ciascun valore di NDVI si è poi fatta un'**analisi ridgeline** dei valori di **NDVI nel 2019 e nel 2025**. Questa permette appunto di creare due curve di distribuzione con cui diventa possibile apprezzare eventuali variazioni nel tempo nella frequenza di NDVI.

``` R
cortina_rl = c(ndvi_19crop, ndvi_25crop)
names(cortina_rl) =c("NDVI 2019", "NDVI 2025")

png("ridgeline_bob.png")
im.ridgeline(cortina_rl, scale=1, palette="viridis")
dev.off()
```

![ridgeline_bob](https://github.com/user-attachments/assets/df6d65dd-6d26-4345-b9f3-8d44858b2a78)

*Il grafico ridgeline che mostra la distribuzione dei valori di NDVI all'interno delle immagini della pista da bob nel 2019 e nel 2025*

Dal grafico si nota un notevole **aumento dei valori di NDVI basso** (ovvero di aree senza vegetazione) nel 2025 rispetto al 2019.  
Questo corrisponde ovviamente all'impatto dei cantieri per l'ammodernamento della pista. A ciò si aggiunge una leggera traslazione nei valori massimi di NDVI, probabilmente dovuta a differenze stagionali tra 2019 e 2025 che hanno influenzato e fatto aumentare l'attività fotosintetica della vegetazione rimasta.

### Composizione delle immagini (classificazione)
Per visualizzare la **variazione percentuale di NDVI nel sito** della pista da bob di Cortina tra 2019 e 2025 è stato creato un **grafico a barre** tramite il pacchetto **ggplot2**. Questo permette di suddividere tutti i pixel di ciascuna immagine in **due classi** a seconda dei loro valori, in questo caso valori elevati di NDVI (vegetazione) e bassi (principalmente edifici, strade o cantieri), per poi confrontarli graficamente.

``` R
cortina_19_class = im.classify(ndvi_19crop, num_clusters=2)            # divido i pixel di ogni immagine in due classi a seconda dei valori
cortina_25_class = im.classify(ndvi_25crop, num_clusters=2)

png("classi_ndvi.png")                                                 # plotto le immagini con i pixel suddivisi nei due cluster per vedere come sono stati classificati e la differenza tra esse
im.multiframe(2,2)
plot(cortina_19_class, main = "Pixel NDVI pista da bob, 2019")
plot(cortina_25_class, main = "Pixel NDVI pista da bob, 2025")
plot(cortina_19_class - cortina_25_class, main = "Differenza NDVI pista da bob\n(2019-2025)")
dev.off()
```

![classi_ndvi](https://github.com/user-attachments/assets/5bcf136c-530e-4b3f-83c3-b9fb9ff57fd8)

*I pixel sono stati suddivisi in due classi (1 e 2), e paragonando queste immagini a quelle NDVI dell'area si vede che la classe 1 corrisponde a valori bassi di NDVI e quella 2 a valori elevati.  
Facendone la differenza risulta evidente dove c'è stata una perdita (in giallo, ovvero la pista da bob) o un mantenimento/aumento (in verde e viola) dei valori di NDVI.*

``` R
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

NDVI = c("elevato", "basso")                                            # creo vettore con i nomi dei due cluster (valore elevato e basso di NDVI)
anno_2019 = c(71.8, 28.2)                                               # creo vettore con le percentuali per ciascun anno
anno_2025 = c(62.5, 37.5)
tabout = data.frame(NDVI, anno_2019, anno_2025)                         # creo dataframe con i valori di ndvi per anno e lo visualizzo
tabout
         NDVI anno_2019 anno_2025
    1 elevato      71.8      62.5
    2   basso      28.2      37.5

ggplotcortina19 = ggplot(tabout, aes(x=NDVI, y=anno_2019, fill=NDVI, color=NDVI)) # creo ggplot per ogni anno
+geom_bar(stat="identity")
+ylim(c(0,100))

ggplotcortina25 = ggplot(tabout, aes(x=NDVI, y=anno_2025, fill=NDVI, color=NDVI))
+geom_bar(stat="identity")
+ylim(c(0,100))

png("ggplot_ndvi.png")
ggplotcortina19 + ggplotcortina25
+ plot_annotation(title = "Valori NDVI (% superficie) nel sito della pista da bob di Cortina")    # creo grafico con entrambi i ggplot creati
dev.off()
```

![ggplot_ndvi](https://github.com/user-attachments/assets/3b63b881-6414-412b-96fd-014fce8aeaf4)

*Dal grafico a barre è evidente l'aumento di pixel con valori bassi di NDVI tra 2019 e 2025 (dal 28% al 38% dell'immagine, ovvero un incremento del 32%) e, ovviamente, una conseguente diminuzione delle aree ricoperte di vegetazione.*


## Analisi delle immagini - San Vito e Tai di Cadore 🛣️
Nelle altre due località interessate dallo studio, il lavoro è stato più ridotto e meno dettagliato rispetto a quello svolto per analizzare il caso di Cortina, concentrandosi esclusivamente sulle immagini satellitari e la differenza visibile tra i due anni tramite analisi multitemporale senza la creazione di grafici.

### Indici spettrali
Per le immagini di San Vito e Tai è stato usato come indice spettrale **solo l'NDVI** in quanto evidenzia in modo più coerente la copertura vegetale in generale, senza enfatizzare eccessivamente le differenze tra vegetazione arborea ed erbacea (come tende invece a fare il DVI).

> I codici utilizzati sono stati gli stessi di quelli utilizzati per le immagini di Cortina d'Ampezzo.

![sanvito_tai_ndvi](https://github.com/user-attachments/assets/9120e58b-a2a6-43e5-a5a8-a33d7c1c3261)

*Come palette di colore è stata lasciata quella standard di viridis per evidenziare al meglio le differenze tra aree senza piante (blu) e fotosintetiche (giallo). In entrambe le immagini del 2025 si nota un leggero aumento rispetto al 2019 della superficie in blu nelle aree interessate dai cantieri.*

### Analisi multitemporale
Anche per le due località del Cadore è stata calcolata la **differenza tra i valori di NDVI** del 2019 e quelli del 2025, per creare un'immagine che rappresentasse le variazioni temporali.

``` R
san_vito_diff_ndvi = ndvi2019sanvito - ndvi2025sanvito
tai_diff_ndvi = ndvi2019tai - ndvi2025tai

png("cadore_diff.png")
im.multiframe(1,2)
plot(san_vito_diff_ndvi, main = "San Vito 2019-2025:\ndifferenza NDVI")
plot(tai_diff_ndvi, main = "Tai 2019-2025:\ndifferenza NDVI")
dev.off()
```

![cadore_diff](https://github.com/user-attachments/assets/2321ee68-e70e-44ce-bb4b-8567992d05b4)

*A San Vito è molto evidente il tracciato della nuova variante stradale affiancata al Boite, mentre a Tai si distinguono i due cantieri degli imbocchi della galleria e dei nuovi svincoli.*

## Risultati e conclusioni ⛷️🌲
L'analisi multitemporale delle immagini satellitari delle tre località della Valle del Boite interessate da opere relative alle Olimpiadi Invernali del 2026 mostra in tutti e tre i casi una **variazione significativa nella copertura vegetale tra 2019 e 2025**, facilmente rilevabile tramite indicatori spettrali come DVI e NDVI.

Lo studio ha approfondito soprattutto l'area del cantiere per il rifacimento della **Pista Olimpica da bob** "Eugenio Monti" in località Ronco a Cortina d'Ampezzo, al centro di un ampio dibattito pubblico e politico sulla sua utilità nel periodo post-olimpico. Nell'area è stato osservato un **notevole abbassamento dei valori di NDVI**, indicativo di una riduzione dell'attività fotosintetica e corrispondente alla rimozione della copertura forestale circostante di abeti e larici. Le immagini classificate mostrano infatti una diminuzione della percentuale di superficie a NDVI elevato dal 71.8% al 62.5%, tendenza confermata anche dal ridgeline plot che evidenzia invece un aumento di pixel con valori di NDVI basso (compatibile con suoli nudi o aree di cantiere).  
L'**impatto spaziale** risulta però **limitato** esclusivamente all'esigua area strettamente circostante alla pista, prossima al centro abitato di Cortina. Le estese foreste di abeti rossi sui versanti circostanti non presentano infatti variazioni significative di NDVI e sono state quindi escluse da parte delllo studio.

![image](https://github.com/user-attachments/assets/f0491ce6-f951-45ed-8580-19c609f42fd3)

Per quanto riguarda le nuove **varianti stradali alla SS51** a San Vito e Tai di Cadore, queste presentano un impatto più contenuto sulla copertura forestale, andando ad interessare soprattutto **zone a prato**, ma su superfici più estese rispetto alla pista da bob. Anche in questi casi la **diminuzione di NDVI**  tra 2019 e 2025 è molto evidente nelle zone dei cantieri.

![image](https://github.com/user-attachments/assets/426f03a7-8588-4049-981f-070567fde673)

Nel complesso, nonostante l'estensione delle opere analizzate nello studio sia quindi circoscritta, gli **effetti sul paesaggio** ampezzano e sull'ambiente della Valle del Boite (già fortemente frammentato, urbanizzato e colpito dalla tempesta Vaia del 2018) non sono trascurabili, anche per quanto riguarda la **continuità ecologica** ed un potenziale incremento del carico turistico associato al miglioramento della viabilità in un'area già soggetta a fenomeni di over-tourism.  
Sarebbe pertanto opportuno ripetere lo studio nei prossimi anni al fine di **monitorare un eventuale recupero della vegetazione** nelle aree disturbate e per **valutare gli effetti indiretti delle infrastrutture viarie** su traffico, emissioni, inquinamento acustico e pressione antropica.
