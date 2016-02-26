woj_sum <- function(w) {
	N.cut <- cut(subset(nazwy, woj==w)$n, breaks, right=FALSE) 
	N.freq <- table(N.cut)
	print ( N.freq )
	print ( N.freq/sum(N.freq) )
	print ( sum(N.freq/sum(N.freq)) )
}

### ### ###

nazwy <- read.csv("nazwy_woj.csv", sep = ';',  header=T, na.string="NA");
#nazwy <- subset (nazwy, (n >1 ));
str(nazwy);
old = options(digits=2) 
##breaks <- seq(1, 30, by=1)
breaks <- c(1, 2, 3, 5, 30)
#breaks

#awkF '$2=="dolnośląskie" { s+= $3}; END { print s}' nazwy_woj.csv
# 2445

woj_sum("dolnośląskie")
woj_sum("kujawsko-pomorskie")
woj_sum("lubelskie")
woj_sum("lubuskie")
woj_sum("łódzkie")
woj_sum("małopolskie")
woj_sum("mazowieckie")
woj_sum("opolskie")
woj_sum("podkarpackie")
woj_sum("podlaskie")
woj_sum("pomorskie")
woj_sum("śląskie")
woj_sum("świętokrzyskie")
woj_sum("warmińsko-mazurskie")
woj_sum("wielkopolskie")
woj_sum("zachodniopomorskie")


nazwy5 <- subset (nazwy, (n >4 ));
nazwy5

#fivenum(nazwy$n);
#mean(nazwy$n);
