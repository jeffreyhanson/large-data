# Simulate the presence of missing data and handle them
# Exercise prepared by Moreno Di Marco - m.dimarco@uq.edu.au
# Data from Penone et al. (2014) Methods in Ecology and Evolution 5(9):961–970, 
# Note: the original dataset contained missing data which have ben imputed to simulate a complete dataset for this exercise


library(randomForest);library(missForest)

# NOTE: change your working directory
setwd("/home/moreno/shared_folder/UQ_ECR_big_data/Missing_Data_practice")


# LOAD AND INSPECT DATA
carnivora_data.complete<-read.csv("carnivora_data_complete.csv")
summary(carnivora_data.complete)


# SET A PROPORTION OF MISSING DATA
md<-0.50


# SIMULATE MISSING DATA

# Simulate missing completely at random MCAR
carnivora_data.mcar=carnivora_data.complete
carnivora_data.mcar$MaxLifespan.m[sample(length(carnivora_data.complete[,1]),length(carnivora_data.complete[,1])*md,replace=FALSE)]<-NA

# Simulate missing at random MAR
carnivora_data.mar=carnivora_data.complete
carnivora_data.mar$MaxLifespan.m[carnivora_data.complete$BodyMass.g<quantile(carnivora_data.complete$BodyMass.g, md)]<-NA

# Simulate missing non at random MNAR
carnivora_data.mnar=carnivora_data.complete
carnivora_data.mnar$MaxLifespan.m[carnivora_data.complete$MaxLifespan.m<quantile(carnivora_data.complete$MaxLifespan.m, md)]<-NA

# inspect the new dataset
summary(carnivora_data.mcar)


# PLOT COMPLETE VS MISSING DATA
par(mfrow=c(1,3))

#MCAR
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,pch=19,col="red",main="MCAR")
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mcar,col="blue",pch=19)
legend("topleft",pch=c(19,19),col=c("blue","red"),c("observed","missing"))

#MAR
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,pch=19,col="red",main="MAR")
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mar,col="blue",pch=19)

#MNAR
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,pch=19,col="red",main="MNAR")
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mnar,col="blue",pch=19)


# CREATE AN ALLOMETRIC MODEL BETWEEN LIFE SPAN AND BODY MASS, FOR EACH INCOMPLETE DATASET
model.complete<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete)
model.mcar<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mcar)
model.mar<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mar)
model.mnar<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mnar)

# check model summaries
summary(model.complete)
summary(model.mcar)
summary(model.mar)
summary(model.mnar)

# compare models coefficiets
model.complete$coefficients
model.mcar$coefficients
model.mar$coefficients
model.mnar$coefficients


# PERFORM MULTIPLE IMPUTATION USING RANDOM FORESTS

# impute mcar dataset
carnivora_data.mcar.imputed<-missForest(carnivora_data.mcar[,2:9], maxiter = 10, ntree = 1000, variablewise = FALSE,
                                   decreasing = TRUE)

# impute mar dataset
carnivora_data.mar.imputed<-missForest(carnivora_data.mar[,2:9], maxiter = 10, ntree = 1000, variablewise = FALSE,
                                        decreasing = TRUE)

# impute mnar dataset
carnivora_data.mnar.imputed<-missForest(carnivora_data.mnar[,2:9], maxiter = 10, ntree = 1000, variablewise = FALSE,
                                        decreasing = TRUE)


# PLOT COMPLETE VS IMPUTED DATASETS
par(mfrow=c(1,3))

# imputed MCAR 
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,col="black",main="MCAR",pch=19)
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mcar.imputed$ximp,col="green")
legend("topleft",pch=c(19,1),col=c("black","green"),c("observed","imputed"))

# imputed MAR
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,col="black",main="MAR",pch=19)
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mar.imputed$ximp,col="green")

# imputed MNAR
plot(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.complete,col="black",main="MNAR",pch=19)
points(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mnar.imputed$ximp,col="green")


# CREATE ALLOMETRIC MODELS BETWEEN LIFE SPAN AND BODY MASS, FOR EACH IMPUTED DATASET
model.mcar.imputed<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mcar.imputed$ximp)
model.mar.imputed<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mar.imputed$ximp)
model.mnar.imputed<-lm(log(MaxLifespan.m)~log(BodyMass.g),data=carnivora_data.mnar.imputed$ximp)

# check model summaries, Note: increased Rsq now, an effect of the imputation
summary(model.complete)
summary(model.mcar.imputed)
summary(model.mar.imputed)
summary(model.mnar.imputed)

# compare coefficiets of imputed datasets
model.complete$coefficients
model.mcar.imputed$coefficients
model.mar.imputed$coefficients
model.mnar.imputed$coefficients


# COMPARE ALL COEFFICIENTS ESTIMATIONS (SLOPES and INTERCEPTS)
par(mfrow=c(2,1),mar=c(4,4,1,1))

# slopes
plot(1,model.complete$coefficients[2],pch=8,ylab="model slope",xlim=c(1,7),ylim=c(0.05,0.25),cex=2,xaxt='n',xlab="")
lines(c(1,7),rep(model.complete$coefficients[2],2),lty=2)
axis(1,1,"complete")

points(2:3,c(model.mcar$coefficients[2],model.mcar.imputed$coefficients[2]),pch=19,col="red",cex=2)
axis(1,2:3,c("MCAR.del","MCAR.imp"))

points(4:5,c(model.mar$coefficients[2],model.mar.imputed$coefficients[2]),pch=19,col="blue",cex=2)
axis(1,4:5,c("MAR.del","MAR.imp"))

points(6:7,c(model.mnar$coefficients[2],model.mnar.imputed$coefficients[2]),pch=19,col="green",cex=2)
axis(1,6:7,c("MNAR.del","MNAR.imp"))

# intercepts

plot(1,model.complete$coefficients[1],pch=8,ylab="model intercept",xlim=c(1,7),ylim=c(3,5),cex=2,xaxt='n',xlab="")
lines(c(1,7),rep(model.complete$coefficients[1],2),lty=2)
axis(1,1,"complete")

points(2:3,c(model.mcar$coefficients[1],model.mcar.imputed$coefficients[1]),pch=19,col="red",cex=2)
axis(1,2:3,c("MCAR.del","MCAR.imp"))

points(4:5,c(model.mar$coefficients[1],model.mar.imputed$coefficients[1]),pch=19,col="blue",cex=2)
axis(1,4:5,c("MAR.del","MAR.imp"))

points(6:7,c(model.mnar$coefficients[1],model.mnar.imputed$coefficients[1]),pch=19,col="green",cex=2)
axis(1,6:7,c("MNAR.del","MNAR.imp"))


# now that the mistery of missing data is solved, go and check Rob's presentation to get confused again!
