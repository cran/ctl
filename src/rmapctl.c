/******************************************************************//**
 * \file Rctl/src/rmapctl.c
 * \brief Implementation of the interfaces to R, and the updateR helper function
 *
 * <i>Copyright (c) 2010-2013</i> GBIC - Danny Arends<br>
 * Last modified Feb, 2013<br>
 * First written 2011<br>
 **********************************************************************/
#include "rmapctl.h"

#ifdef USING_R

void updateR(bool flush){
  R_CheckUserInterrupt();
  if(flush) R_FlushConsole();
}

void R_mapctl(int* nind, int* nmar, int* nphe, int* geno, double* pheno, int* p, 
              int *nperms, int* permt, int* nthr, double* dcor,  double* perms, double* res, int* adj, int* verb){
  GetRNGstate();
  int nindividuals  = (int)(*nind);
  int nmarkers      = (int)(*nmar);
  int nphenotypes   = (int)(*nphe);
  int phenotype     = (int)(*p);
  int npermutations = (int)(*nperms);
  int permtype      = (int)(*permt);
  int nthreads      = (int)(*nthr);
  int adjust       = (int)(*adj);
  int verbose       = (int)(*verb);

  if(verbose) info("R_mapctl, verbose=%d", verbose);

  Phenotypes phenotypes;
  Genotypes  genotypes;
  int        i,ph,perm;
  double**   dcors;
  double**   ctls;
  
  phenotypes.data = asdmatrix(nphenotypes, nindividuals, pheno);
  phenotypes.nphenotypes = nphenotypes;
  phenotypes.nindividuals = nindividuals;
  
  genotypes.data = asimatrix(nmarkers, nindividuals, geno);
  genotypes.nmarkers = nmarkers;
  genotypes.nindividuals = nindividuals;

  clvector* genoenc = getGenotypes(genotypes, false);

  if(verbose) info("Phenotype %d: Mapping", (phenotype+1));  
  updateR(1);
  dcors = ctleffects(phenotypes, genotypes, phenotype, genoenc, nthreads, verbose);

  for(i = 0; i < (nphenotypes*nmarkers); i++){    // Send scores to R
    int m = i % nmarkers; int p = i / nmarkers;
    dcor[i] = dcors[m][p];
  }

  if(permtype == 1){
    if(verbose) info(", Full permutation%s", "");
    updateR(1);
    double* permutations = permute(phenotypes, genotypes, phenotype, genoenc, 
                                   npermutations, nthreads, false);
    for(i=0; i < npermutations; i++){           // Send permutations to R
      perms[i] = permutations[i];
    }
    if(verbose) info(", toLOD%s\n", "");
    updateR(1);
    ctls = toLOD(dcors, permutations, genotypes.nmarkers, phenotypes.nphenotypes, npermutations);
    free(permutations);
  }else if(permtype == 2){
    if(verbose) info(", Pairwise permutation%s", "");
    updateR(1);
    double** permutations = permuteRW(phenotypes, genotypes, phenotype, genoenc, 
                                      npermutations, nthreads, false);
    for(ph=0; ph < (nphenotypes); ph++){         // Send permutations to R
      for(perm=0; perm < (npermutations); perm++){
        perms[(ph*npermutations)+perm] = permutations[ph][perm];
      }
    }
    if(verbose) info(", toLOD%s\n", "");
    ctls = toLODRW(dcors, permutations, genotypes.nmarkers, phenotypes.nphenotypes, npermutations);
    freematrix((void**)permutations, nphenotypes);
  }else{
    if(verbose) info(", toLOD%s\n", "");
    updateR(1);
    ctls = toLODexact(dcors, genoenc, genotypes.nmarkers, phenotypes.nphenotypes, adjust);
  }
  for(i=0; i < (nphenotypes*nmarkers); i++){
    int m = i % nmarkers;
    int p = i / nmarkers;
    res[i] = ctls[m][p];
  }
  for(i = 0; i < nmarkers; i++){ free(genoenc[i].data); }
  PutRNGstate();
  free(genoenc);
  
  // The indices are allocated by C
  free(genotypes.data);
  free(phenotypes.data);
  
  freematrix((void**)dcors, genotypes.nmarkers);
  freematrix((void**)ctls, genotypes.nmarkers);
  return;
}

#endif //USING_R
