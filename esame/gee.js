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

function maskS2clouds(image) {      // per mascherare le nuvole usando la banda QA60
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;      // nuvole opache
  var cirrusBitMask = 1 << 11;     // cirri
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));    // per tenere solo i pixel in cui nuvole e cirri siano 0
  return image.updateMask(mask).divide(10000);    // maschera nuvole e valori di riflettanza scalati (0–10000 ➝ 0–1)
}

// preparazione della collezione di immagini
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(cortina)                                // area di interesse = poligono cortina
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

// esportazione dell'immagine in GDrive (con bande red, green, blue)
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),  // selezione bande RGB
  description: 'cortina_19',
  folder: 'GEE_exports',                        // nome cartella in GDrive
  fileNamePrefix: 'cortina_19',                 // nome file
  region: cortina,                              // area di interesse
  scale: 10,                                    // risoluzione di Sentinel-2 (10 km)
  crs: 'EPSG:32632',                            // sistema di riferimento per l'Italia
  maxPixels: 1e13
});

// ripetizione dell'esportazione ma con bande NIR, red, green
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),  // selezione banda B8 (NIR)
  description: 'cortina_19_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'cortina_19_nir',
  region: cortina,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});


// ====================== ripetizione processo per immagini del 2025 ========================
function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(cortina)
                   .filterDate('2025-05-01', '2025-06-30')              // date del 2025
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);
var composite = collection.median().clip(cortina);
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),
  description: 'cortina_25',
  folder: 'GEE_exports',
  fileNamePrefix: 'cortina_25',
  region: cortina,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),
  description: 'cortina_25_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'cortina_25_nir',
  region: cortina,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});


// ====================== ripetizione processo per l'area di San Vito di Cadore ========================
var san_vito = 
    ee.Geometry.Polygon(
      [[[12.193006447322698, 46.471473706914416],
        [12.193006447322698, 46.447113727544775],
        [12.223905495174261, 46.447113727544775],
        [12.223905495174261, 46.471473706914416]]], null, false);
    Export.table.toDrive({
  collection: ee.FeatureCollection(ee.Feature(san_vito)),
  description: 'export_san_vito_aoi',
  folder: 'GEE_exports',
  fileFormat: 'GeoJSON'
});

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(san_vito)
                   .filterDate('2019-05-01', '2019-06-30')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);
var composite = collection.median().clip(san_vito);
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),
  description: 'san_vito_19',
  folder: 'GEE_exports',
  fileNamePrefix: 'san_vito_19',
  region: san_vito,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),
  description: 'san_vito_19_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'san_vito_19_nir',
  region: san_vito,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(san_vito)
                   .filterDate('2025-05-01', '2025-06-30')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);
var composite = collection.median().clip(san_vito);
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),
  description: 'san_vito_25',
  folder: 'GEE_exports',
  fileNamePrefix: 'san_vito_25',
  region: san_vito,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),
  description: 'san_vito_25_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'san_vito_25_nir',
  region: san_vito,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});


// ====================== ripetizione processo per l'area di Tai di Cadore ========================
var tai =
    ee.Geometry.Polygon(
      [[[12.339676841100946, 46.432599317650634],
        [12.339676841100946, 46.41271956415987],
        [12.376927359899774, 46.41271956415987],
        [12.376927359899774, 46.432599317650634]]], null, false);
     Export.table.toDrive({
    collection: ee.FeatureCollection(ee.Feature(tai)),
    description: 'export_tai_aoi',
    folder: 'GEE_exports',
    fileFormat: 'GeoJSON'
 });

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(tai)
                   .filterDate('2019-05-01', '2019-06-30')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);
var composite = collection.median().clip(tai);
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),
  description: 'tai_19',
  folder: 'GEE_exports',
  fileNamePrefix: 'tai_19',
  region: tai,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),
  description: 'tai_19_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'tai_19_nir',
  region: tai,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});

function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
               .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}
var collection = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(tai)
                   .filterDate('2025-05-01', '2025-06-30')
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
                   .map(maskS2clouds);
var composite = collection.median().clip(tai);
Map.addLayer(composite, {
  bands: ['B4', 'B3', 'B2'],
  min: 0,
  max: 0.3
}, 'Median composite');
Export.image.toDrive({
  image: composite.select(['B4', 'B3', 'B2']),
  description: 'tai_25',
  folder: 'GEE_exports',
  fileNamePrefix: 'tai_25',
  region: tai,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
Export.image.toDrive({
  image: composite.select(['B8', 'B4', 'B3']),
  description: 'tai_25_nir',
  folder: 'GEE_exports',
  fileNamePrefix: 'tai_25_nir',
  region: tai,
  scale: 10,
  crs: 'EPSG:32632',
  maxPixels: 1e13
});
