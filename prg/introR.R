# ****************************
# Introduction à R - RAPPELS *
# ****************************

# variables, affectations, opérations

a <- 5
A <- 17
b <- 6
c <- a + b
toto <- 5
toto <- "bonjour"

# Les vecteurs

c(1,2,3,4,5,6)
chiffres <- c(1,4,8,9,12,3,7,6,11,5,10,2)
chiffres
class(chiffres)
chiffres2 <- sort(chiffres,decreasing = FALSE)
chiffres
sum(chiffres)
chiffres2

animaux <- c("Chien", "Chat", "Lapin", "Grenouille", 
             "Crocodile", "Serpent", "Girafe","Zébu","pingouin")
animaux2 <- sort(animaux,decreasing = TRUE)
animaux2

class(animaux)
length(animaux)

monanimal <- animaux[3]
mesanimaux <- c(3,5)
animaux[mesanimaux]

animaux[2:5]

?length # Acceder à l'aide

animaux[c(1,length(animaux))]


# seq(1,10,3)
# rep( c(1,3), c(2,3) )

# Les dataframe : data.frame()

# 1ere facon de faire
tableau.df <- data.frame(prenom = c("Herbie","Miles","Julien","Thelonious"),
                         nom=c("Hancock", "Davis", "Lourau", "Monk"))
tableau.df

# 2e facon de faire
noms <- c("Hancock", "Davis", "Lourau", "Monk","toto")
prenoms <-   c("Herbie","Miles","Julien","Thelonious","Herbie")
age <- c(97, 27, 65, 53,8)
tableau.df <- data.frame(prenoms, noms, age)
tableau.df

dim(tableau.df)
rownames(tableau.df)
rownames(tableau.df) <- c("a","b","c","d")

colnames(tableau.df)

tableau.df[1,]  # Sélectionner une ligne
tableau.df[,2] # Sélectionner une colonne
tableau.df$prenoms # Sélectionner une colonne
tableau.df[,"prenoms"] # Sélectionner une colonne
tableau.df[1,1] # Sélectionner une valeur
tableau.df[4,2] # Sélectionner une valeur
tableau.df[1,"prenoms"] # Sélectionner une valeur


tableau.df$prenoms
class(tableau.df$prenoms)
levels(tableau.df$prenoms)

# Ouvrir un ficher de données

getwd()
#setwd("/home/nlambert/Documents/R/tunisie")

my.df <- read.csv("data/data_carto_census2014.csv",header=TRUE,sep=";",dec=",")
my.df
head(my.df,4)
View(my.df)

my.df$log_t_2014
summary(my.df$log_t_2014)

# Extraire un vecteur
myvecteur <- my.df$id
myvecteur

# Ajouter une colonne

my.df$poplog <- my.df$pop_t_2014 /  my.df$log_t_2014
head(my.df,4)
my.df$poplog<- round(my.df$poplog,1)
head(my.df,4)
?round

# Sauvegarder le fichier

write.table(x = my.df,file = "nouveaufichier.tsv",sep="\t")

?write.csv


# PAUSE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# Ajouter des données géométriques

#install.packages("rgdal") #executer une seule fois
library("rgdal")

# Importer un shapfile
# monFondDeCarte <-readOGR(dsn ="/repertoire-de-travail",layer = "nom-de-la-couche")

# Importer un ficher shapfile

# Chemin absolu
monFondDeCarte <-readOGR(dsn ="/home/nlambert/Desktop/shapfile",layer = "delegations")

# Chemin relafif
setwd("/home/nlambert/Desktop/") # je défini mon  répertoire de travail
monFondDeCarte <-readOGR(dsn ="shapfile",layer = "delegations",encoding = "UTF-8")

#delegations.spdf <- readOGR(dsn = "data/TN-delegations.geojson", layer = "OGRGeoJSON")

# Explorer le ficher
class(monFondDeCarte)
proj4string(monFondDeCarte)
monFondDeCarte@data
head(monFondDeCarte@data)

nomsdelegations <- monFondDeCarte@data$del_fr
monFondDeCarte@data[,2]

# Afficher
plot(monFondDeCarte)
plot(monFondDeCarte,col="#FF0000",border="white",lwd=0.6)

# Import des données attributaires

donnees <- read.csv("data_carto_census2014.csv",header=TRUE,sep=",",dec=".")

# Vérification

head(monFondDeCarte@data,4)
head(donnees,4)

# Jointure

monFondDeCarte@data <- data.frame(monFondDeCarte@data, donnees[match(monFondDeCarte@data[,"id"], donnees[,"id"]),])
names(monFondDeCarte@data )
monFondDeCarte@data <- monFondDeCarte@data[,c("id","del_fr","pop_t_2014")]
# Exporter au format shapfile
writeOGR(obj=monFondDeCarte, dsn="outputs", layer="monshapefile", driver="ESRI Shapefile")
getwd()
