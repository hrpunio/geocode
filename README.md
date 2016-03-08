# geocode
Dnia 19 października 2015 r. zostało opublikowane w Dzienniku Ustaw (poz. 1636)
obwieszczenie Ministra Administracji i Cyfryzacji z dnia 4 sierpnia 2015 r.
w sprawie wykazu urzędowych nazw miejscowości i ich części

W wykazie uwzględniono 103086 nazw, w tym 915 nazw miast, 6710 nazw części miast,
43068 nazw wsi, 36263 nazwy części wsi, 5132 nazwy osad. [Z czego wynika, że
wsi+miast jest 43068 + 915 = 43983 nazw

http://ksng.gugik.gov.pl/urzedowe_nazwy_miejscowosci.php

Wypisz wg województw
--------------------
perl sum.pl urzedowy_wykaz_nazw_miejscowosci_2015.csv | grep '###'  | awkF '{print $2 ";" $3 ";" $4}' > nazwy_woj.csv

Wypisz łącznie dla całej Polski
-------------------------------
perl sum.pl urzedowy_wykaz_nazw_miejscowosci_2015.csv | grep '==='  | awkF '{print $2 ";" $3 }' > nazwy_pol.csv

grep ";wieś\|miasto;" urzedowy_wykaz_nazw_miejscowosci_2015.csv | awkF 'BEGIN {OFS=";"}; \
   {print $1, $2, $3, $4, $5, $6 }' > nazwy_pl.csv


Wypisz pomorskie i zachodnio-pomorskie adresy okręgów wyborczych
----------------------------------------------------------------

awk -F ';' '$2 ~ /^22/ {print $0}' kody_adresy_poprawiony_Coords.csv  | wc -l
$1453

# ręcznie usuwamy statki tj.:
# 103138;229801;Baltica 103139;229801;Le Quy Don 103140;229901;Oceania
# 103141;229901;Baltic Beta 103142;229901;LOTOS Petrobaltic

# zachodnio-pomorskie 
awk -F ';' '$2 ~ /^32/ {print $0}' kody_adresy_poprawiony_Coords.csv >> kody_adresy_poprawiony_Coords_Pomorskie.csv

wc -l kody_adresy_poprawiony_Coords_Pomorskie.csv 
$2574 kody_adresy_poprawiony_Coords_Pomorskie.csv

# adresy zdublowane kończą się na CX;CX;CX
grep -v 'CX;CX' kody_adresy_poprawiony_Coords_BB_Pomorskie.csv | wc -l
$2302

grep -v 'CX;CX' kody_adresy_poprawiony_Coords_BB_Pomorskie.csv | grep ROOFTOP | wc -l
$1858  ## 80,71%

## Kompletnie bez sensu (wskazanie Poland jako obszaru)
awk -F ';'  '{ print $(NF-1) }' kody_adresy_poprawiony_Coords_BB_Pomorskie.csv | grep "^Poland$" | wc -l
$210 ## 9,12%

# lista dziwnych adresów
grep -v 'CX;CX;' kody_adresy_poprawiony_Coords_BB_Pomorskie.csv | awk -F ';'  '$(NF-1) == "Poland" { print $0 }'

# liczba dziwnych adresów
grep -v 'CX;CX;' kody_adresy_poprawiony_Coords_BB_Pomorskie.csv | awk -F ';'  '$(NF-1) == "Poland" { print $0 }' | wc -l
$210

