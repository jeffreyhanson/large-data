#Exercises for data pre-processing
#Author: if(works=T) {Rob Salguero-Gomez} else
#                     {Moreno di Marco}

#Deleting any trash in your memory
rm(list=ls(all=TRUE))

#Set writing directory. You'll have to change it to wherever you have got the data in your computer
setwd("~/Desktop")

#Read dataframe with demographic info from COMPADRE
d1=read.csv("Demographic covariates - Sep 11 2015.csv")
dim(d1)
head(d1)

subsetD=d1[grep("r",d1$species),]
dim(subsetD)
subsetD=d1[grep("re",d1$species),]
dim(subsetD)
subsetD=d1[grep("Ophrys",d1$species),]
dim(subsetD)

subsetD=subset(d1,dim>4)
dim(subsetD)
subsetD=subset(d1,dim>10)
dim(subsetD)

d1$R0
length(which(is.na(d1$R0)==T))
subsetD=subset(d1,!is.na(R0))
dim(subsetD)
subsetD=d1[which(!is.na(d1$R0)),]
dim(subsetD)

#How to evaluate NAs by rows and by columns
barplot(colSums(is.na(d1)),rownames=colnames(d1),las=2)
barplot(rowSums(is.na(d1)),rownames=colnames(d1),las=2)

#Read dataframe with ecological info
d2=read.csv("SpeciesDescriptors Sep 17 2013.csv")
dim(d2)
head(d2)

#What happens if you try to rbind the data?
d3=rbind(d1,d2)
d3=rbind(d1[,1:dim(d2)[2]],d2)
names(d1)
names(d2)

#Does cbinding work better?
d4=cbind(d1,d2)
dim(d4)
dim(d1)
dim(d2)
head(d4)

#Let's try with merging
d5=merge(d1,d2,by.x="species",by.y="species")

#What if I am now dealing with a database with different number of species?
d6=d1
dim(d6)
d6$species=as.character(d6$species)
dummy=c("SpeciesMadeUp",rep(NA,dim(d1)[2]-1))
d6=rbind(d6,dummy)
dim(d6)

d6$species=as.factor(d6$species)

d7=merge(d6,d2,by="species")
dim(d7)

d7=merge(d6,d2,by="species",all=T)
dim(d7)

d7=merge(d6,d2,by="species",all.x=T)
dim(d7)

d7=merge(d6,d2,by="species",all.y=T)
dim(d7)



#Intersect, union, difference

speciesList1=d1$species[c(1,5,6,9,13,65,123,125,256)]
speciesList1
speciesList2=d2$species[c(1,5,6,10,50,60,90,130,450,231,251,456)]
speciesList2

intersect(speciesList1,speciesList2)
speciesList1[which(speciesList1%in%speciesList2)]

setdiff(speciesList1,speciesList2)
speciesList1[which(!speciesList1%in%speciesList2)]

union(speciesList1,speciesList2)


#So when is this any helpful?
#Imagine that you've got a phylogeny and you want to put some life history trait in the context of phylogenetic ancestry. The first thing to do is to match the dataframe to what's in your tree's nodes

library(ape)
Tree=read.nexus("PMDbl260314.nex")
plot(Tree)

d1$species=as.character(d1$species)
missingSpecies=d1$species[!d1$species%in%Tree$tip.label]
missingSpecies

d1=d1[-which(d1$species%in%missingSpecies),]
dim(d1)

#Which species are duplicated in d1?
duplicatedSpecies=which(duplicated(d1$species)==TRUE)

toDrop = Tree$tip.label[!Tree$tip.label %in% d1$species]
toDrop

newTree = drop.tip(Tree,toDrop)
plot(newTree)
DF = subset(d1,species %in% newTree$tip.label)
dim(DF)

library(caper)
compData = comparative.data(newTree, DF, names.col="species")

#And it doesn't work! yay... let's blame Moreno... Rob will fix this tonight



