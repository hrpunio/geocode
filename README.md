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

