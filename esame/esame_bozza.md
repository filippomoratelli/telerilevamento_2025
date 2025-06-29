### Filippo Moratelli --- matricola n. 
# L'impatto ambientale dei XXV Giochi Olimpici Invernali sulla Valle del Boite (BL) 🏔️

In questo lavoro è stato analizzato tramite telerilevamento satellitare l'impatto sulla copertura forestale di alcune opere relative ai **XXV Giochi Olimpici Invernali**, previsti a Milano, Cortina d'Ampezzo e altre località delle Alpi Italiane per il febbraio 2026.

Nel dettaglio, è stata confrontata la situazione tra il 2019 e il 2025 in alcune località situate in **Valle del Boite** (provincia di Belluno) interessate da opere direttamente o indirettamente connesse alle Olimpiadi, ovvero:
+ **Cortina d'Ampezzo**, sede dei Giochi, presso cui sono recentemente terminati i lavori per l'ammodernamento della **Pista Olimpica *"Eugenio Monti"*** dove si terranno le discipline di bob, slittino e skeleton;
+ **San Vito di Cadore**, dove sono in corso i lavori per la costruzione di una **variante stradale alla Strada statale 51 di Alemagna** che permetta di alleggerire il traffico all'interno del centro cittadino;
+ **Tai di Cadore**, dove sempre per la SS51 è in costruzione una **galleria stradale** a sud dell'abitato in modo da evitarne l'attraversamento.

![esame_telerilev](https://github.com/user-attachments/assets/147f6c3b-46e0-437e-b012-b8cda0b99198)
*Le tre aree analizzate dallo studio e la loro collocazione all'interno della Regione Veneto*


## Metodi 🛰️
### Download delle immagini
Le immagini satellitari utilizzate provengono dalla missione ESA **Sentinel-2** e sono state ottenute tramite la piattaforma di **Google Earth Engine**, permettendo quindi di avere accesso anche alle immagini più recenti e aggiornate possibili (giugno 2025).

Come anno base di partenza è stato scelto il **2019**, anno di assegnazione dei Giochi Olimpici a Milano e Cortina e quindi precedente all'inizio di qualsiasi lavoro effettivamente collegato alle Olimpiadi, e inoltre successivo alla tempesta Vaia, escludendo quindi dall'analisi eventuali variazioni nella copertura arborea dovute ai danni da vento.

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

// ====================== ripetizione processo per lo stesso periodo del 2025 e per le altre due località ========================
var san_vito = 
    ee.Geometry.Polygon(
      [[[12.193006447322698, 46.471473706914416],
        [12.193006447322698, 46.447113727544775],
        [12.223905495174261, 46.447113727544775],
        [12.223905495174261, 46.471473706914416]]], null, false);
var tai =
    ee.Geometry.Polygon(
      [[[12.339676841100946, 46.432599317650634],
        [12.339676841100946, 46.41271956415987],
        [12.376927359899774, 46.41271956415987],
        [12.376927359899774, 46.432599317650634]]], null, false);
```

### Importazione in R - Cortina
Le immagini sono state poi scaricate da Google Drive, trasferite in una cartella apposita e successivamente ricaricate in **R** tramite il **pacchetto terra**.
Altri pacchetti utilizzati sono stati:
+ **imageRy**, per la funzione di plot;
+ **viridis**, per le palette di colori;
+ **ggridges**, per creare plot ridgeline.
  
È stata poi fatta una prima analisi per confrontare l'area di Cortina d'Ampezzo tra il 2019 e il 2025 con i colori reali (bande RGB) e visualizzando il suolo nudo utilizzando la banda del vicino infrarosso al posto della banda blu.

```
setwd("/Users/filippomoratelli/Desktop/UniBo/corsi/telerilevamento/esame") # imposto la work directory
library(terra)                            # carico i pacchetti necessari
library(imageRy)
library(viridis)

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

*Le quattro immagini di confronto per l'area di Cortina d'Ampezzo, in colori reali (RGB) e usando la banda del vicino infrarosso per evidenziare il suolo nudo (in giallo) rispetto alla copertura vegetale (in blu). Si nota l'area della pista da bob al centro delle immagini del 2025, in località Ronco, e le piste da sci del Col Drusciè sulla sinistra.*

### Importazione in R - San Vito e Tai di Cadore
Lo stesso procedimento, con gli stessi codici, è stato poi ripetuto per le immagini delle altre due località interessate dallo studio.

![san_vito](https://github.com/user-attachments/assets/1a81cef1-6661-46e4-87ad-27f71c13d47a)

*Nelle immagini si nota il cantiere per la costruzione della variante della SS51 ad ovest del centro abitato di San Vito di Cadore, parallela al torrente Boite.*

![tai](https://github.com/user-attachments/assets/597c5426-4f4f-4636-9563-eb4220cf3b77)

*In queste immagini si può notare, a sud dell'abitato di Tai di Cadore, l'impatto della costruzione della galleria dell'altra variante della SS51 e delle opere annesse.*

## Analisi delle immagini
### Indici spettrali - Cortina d'Ampezzo 🛷
Si è poi proceduto a visualizzare le variazioni di **DVI** (Difference Vegetation Index) e **NDVI** (Normalized Difference Vegetation Index), che calcolano la differenza tra la banda del vicino infrarosso e quella del rosso per valutare lo stato di salute (o, in questo caso, la presenza) delle piante. L'NDVI viene normalizzato (valori tra -1 e +1) calcolando anche il rapporto tra differenza e somma di NIR e Red.

```
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

### Indici spettrali - San Vito e Tai di Cadore 🛣️
Per le immagini delle altre località è stato usato come indice spettrale **solo l'NDVI** in quanto evidenzia in modo più coerente la copertura vegetale in generale, senza senza enfatizzare eccessivamente le differenze tra vegetazione arborea ed erbacea (come tende a fare il DVI).
I codici utilizzati sono stati gli stessi di quelli utilizzati per le immagini di Cortina d'Ampezzo.

![sanvito_tai_ndvi](https://github.com/user-attachments/assets/9120e58b-a2a6-43e5-a5a8-a33d7c1c3261)

*Come palette di colore è stata lasciata quella standard di viridis per evidenziare al meglio le differenze tra aree senza piante (blu) e fotosintetiche (giallo). Si notano bene gli impatti dei cantieri stradali.*

### Analisi multitemporale - Cortina d'Ampezzo 🛷
Per visualizzare meglio l'impatto dei lavori per la pista da bob è stata calcolata la **differenza tra le immagini del 2019 e del 2025** per quanto riguarda la **banda del verde** e i valori di **NDVI**.
```
cortina_diff = cortina_19[[2]] - cortina_25[[2]]        # calcolo differenza nella banda del verde tra 2019 e 2025
cortina_diff_ndvi = ndvi2019cortina - ndvi2025cortina   # calcolo differenza NDVI
png("cortina_diff.png")
im.multiframe(1,2)                                      # plotto le due immagini insieme
plot(cortina_diff, main = "Cortina 2019-2025:\ndifferenza banda del verde")
plot(cortina_diff_ndvi, main = "Cortina 2019-2025:\ndifferenza NDVI")
dev.off()
```

![cortina_diff](https://github.com/user-attachments/assets/fa361dbb-e722-44a7-b41d-8878e7b95e31)

*In entrambe le immagini è ben visibile una "macchia" di colore diverso al centro dell'immagine in corrispondenza della pista da bob, dove i lavori hanno infatti comportato l'abbattimento di numerosi alberi, principalmente larici e abeti.*

### Analisi multitemporale - San Vito e Tai di Cadore 🛣️
Lo stesso procedimento è stato ripetuto per le due località del Cadore, ma solo relativamente ai valori di **NDVI** in quanto vengono visualizzati in maniera più evidente.

```
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

