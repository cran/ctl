### R code from vignette source 'manual.Rnw'

###################################################
### code chunk number 1: manual.Rnw:38-40
###################################################
options(width=87, digits=3, scipen=4)
set.seed(61777369)


###################################################
### code chunk number 2: manual.Rnw:143-151 (eval = FALSE)
###################################################
##   setwd("/Path/To/Data/")
##   genotypes <- read.csv("genotypes.csv",row.names=1, header=FALSE,sep="\t")
##   traits <- read.csv("phenotypes.csv",row.names=1, header=FALSE,sep="\t")
##   genotypes[1:5,1:10]    #Show 5 individuals, 8 markers, and genetic locations
##   traits[1:5,1:10]       #Show 5 individuals, 8 traits, and genetic locations
##   mapinfo <- genotypes[,1:2]
##   genotypes <- genotypes[,-c(1,2)]  # Remove the genetic locations
##   traits <- traits[,-c(1,2)]        # Remove the genetic locations


###################################################
### code chunk number 3: manual.Rnw:161-165 (eval = FALSE)
###################################################
## require(qtl)        #Loads the R/qtl package
## data(multitrait)    #Loads the dataset
## multitrait          #Print basic dataset information
## ?read.cross         #List of formats supported by R/qtl


###################################################
### code chunk number 4: manual.Rnw:187-189 (eval = FALSE)
###################################################
## mapinfo <- read.csv("mapinfo.csv",row.names=1,col.names=TRUE)
## mapinfo[1:5,1:3]     #Show the first 5 marker records


###################################################
### code chunk number 5: manual.Rnw:199-206 (eval = FALSE)
###################################################
## require(ctl)                     #Loads the R/ctl package
## data(ath.metab)                  #Loads the example dataset
## geno   <- ath.metab$genotypes    #Short name
## traits <- ath.metab$phenotypes   #Short name
## 
## #Scan all phenotypes for CTLs, using the default options (Could take some time)
## ctls   <- CTLscan(geno,traits)


###################################################
### code chunk number 6: manual.Rnw:211-214 (eval = FALSE)
###################################################
## library(qtl)
## data(multitrait)
## ctls   <- CTLscan.cross(multitrait)


###################################################
### code chunk number 7: manual.Rnw:226-228 (eval = FALSE)
###################################################
## #Load a dataset with "AA" and "AB" genotypes
## ctls <- CTLscan(geno,traits,geno.enc=c("AA","AB"))


###################################################
### code chunk number 8: manual.Rnw:233-235 (eval = FALSE)
###################################################
## ctls_quick_scan      <- CTLscan(geno,traits,n.perm=100)
## ctls_for_publication <- CTLscan(geno,traits,n.perm=15000)


###################################################
### code chunk number 9: manual.Rnw:244-249 (eval = FALSE)
###################################################
## #Specify that individuals 1:51 were in condition A / e.g. treatment A
## #Specify that individuals 52:100 were in condition B / e.g. treatment B 
## #Specify that individuals 101:162 were in condition C / e.g. control
## conditions <- c(rep(1,51),rep(2,49),rep(3,62))
## ctls <- CTLscan(geno, traits, conditions=conditions)


###################################################
### code chunk number 10: manual.Rnw:256-260 (eval = FALSE)
###################################################
## require(qtl)        #load the R/qtl package
## data(multitrait)    #load the dataset
## oneqtls   <- scanone(multitrait, pheno.col=1:24)[,-c(1,2)]
## ctls_one  <- CTLscan.cross(multitrait, pheno.col=1:2, have.qtl=qtls)


###################################################
### code chunk number 11: manual.Rnw:266-269 (eval = FALSE)
###################################################
## cofactors <- mqmautocofactors(multitrait, 30)
## mqm_qtls  <- mqmscan(multitrait, cofactors=cofactors, pheno.col=1:24)[,-c(1,2)]
## ctls_mqm  <- CTLscan.cross(multitrait, pheno.col=1:2, have.qtl=qtls)


###################################################
### code chunk number 12: manual.Rnw:280-281 (eval = FALSE)
###################################################
## image(ctls,against="markers")


###################################################
### code chunk number 13: manual.Rnw:285-286 (eval = FALSE)
###################################################
## image(ctls,against="phenotypes")


###################################################
### code chunk number 14: manual.Rnw:291-292 (eval = FALSE)
###################################################
## ctls[[1]]


###################################################
### code chunk number 15: manual.Rnw:297-298 (eval = FALSE)
###################################################
## plot(ctls[[1]])


###################################################
### code chunk number 16: manual.Rnw:307-308 (eval = FALSE)
###################################################
## sign <- CTLsignificant(ctl_scan)


###################################################
### code chunk number 17: manual.Rnw:317-318 (eval = FALSE)
###################################################
## ctl_network <- CTLnetwork(ctls, lod.threshold = 5, mapinfo)


###################################################
### code chunk number 18: manual.Rnw:357-358 (eval = FALSE)
###################################################
## ctls <- read.dctl("genotypes.csv","phenotypes.csv",results="<PATH>/output/")


