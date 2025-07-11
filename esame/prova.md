# esame 👨‍🎓

+ specificare codice, **JavaScript** è scritto tutto attaccato con due maiuscole
+ il DVI e l’NDVI (con questi **articoli**)
+ **È**, non E’ 
+ **maiuscole e minuscole** uniformi, anche nei nomi dei file
+ no **doppi spazi**
+ eventuali **formule** = good
+ qualche **emoji** relativa a quanto scritto ✍️
+ chiamarle **immagini** non foto
+ sapere da che **pacchetti** vengono le funzioni (unica cosa che ha chiesto)
+ no **errori di battitura**

## formule

````md
$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$
(usando formattazione LaTeX)
````

$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$

## robine cute 🐈
````md
>[!WARNING]
> bla bla

>[!NOTE]
> bla bla

>[!IMPORTANT]
> bla bla

>[!TIP]
> bla bla

> [!CAUTION]
> ciao
````

>[!WARNING]
> bla bla

>[!NOTE]
> bla bla

>[!IMPORTANT]
> bla bla

>[!TIP]
> bla bla

> [!CAUTION]
> ciao

## immagine al centro 🖼️
````md
<p align="center">
  <immagine/>
</p>
````
<p align="center">
  <img width="480" height="480" alt="cortina_diff_ndvi" src="https://github.com/user-attachments/assets/b19ba40f-bb6e-4ace-856d-f54a36bf624d" />
</p>

## codice nascosto (più ordinato?) 🐣

````md
<details>
<summary>codice 1 (cliccare qui)</summary>
  perché funzioni deve esserci una riga vuota prima del codice
  
  ``` r
  bla bla
  codice R
  ciao
  ```
</details>
````
<details>
<summary>codice 1 (cliccare qui)</summary>
  perché funzioni deve esserci una riga vuota prima del codice
  
  ``` r
  bla bla
  codice R
  ciao
  ```
</details>

## grassetto, corsivo, apice, pedice
````md
*ciao*

**ciao**

***ciao***

ciao<sup>ciao</sup>

ciao<sub>ciao</sub>

````
*ciao*

**ciao**

***ciao***

ciao<sup>ciao</sup>

ciao<sub>ciao</sub>

## linee orizzontali
````md
 
---
````
riga vuota + tre trattini = linea orizzontale

---

## andare a capo senza fare nuovo paragrafo
dopo l'ultima parola doppio spazio e a capo

````md
ciao + due spazi qui ->    
ciao
````

ciao  
ciao

---
che viene diverso da:

````md
ciao
 
ciao
````

ciao

ciao (con una riga vuota tra i ciao)

---
andando solo a capo senza doppio spazio non va davvero a capo

````md
ciao
ciao
````

ciao
ciao
