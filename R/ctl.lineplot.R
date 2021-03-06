#
# ctl.lineplot.R
#
# copyright (c) 2010-2012 - GBIC, Danny Arends and Ritsert C. Jansen
# last modified Dec, 2012
# first written Dec, 2012
# 
# Line plot routines for CTL analysis
#

ctl.lineplot <- function(CTLobject, mapinfo, phenocol, significance = 0.05, gap = 50, col="orange", bg.col = "lightgray", cex = 1, verbose = FALSE){
  if(missing(CTLobject) || is.null(CTLobject)) stop("argument 'CTLobject' is missing, with no default")
  if(missing(phenocol)) phenocol <- 1:length(CTLobject) 
  n.markers  <- nrow(CTLobject[[1]]$ctl)
  ctls       <- CTLnetwork(CTLobject, mapinfo, significance, verbose = verbose)
  CTLobject  <- CTLobject[phenocol]
  ctls       <- ctls[which(ctls[,1] %in% phenocol),]
  if("numeric" %in% class(ctls)) ctls <- t(ctls)
  if(is.null(ctls) || nrow(ctls) < 1) {
    warning(paste("No ctls edges found at significance <", significance))
    plot(c(-1,1),c(-1,1),t='n', axes = FALSE, xlab = "", ylab = "")
    box()    
    return()
  }
  markerlocs <- cbind(seq(1,n.markers),rep(0,n.markers))
  total.l    <- n.markers  
  if(!missing(mapinfo)){
    markerlocs <- mapinfotomarkerlocs(mapinfo, gap, "line")
    total.l    <- max(markerlocs[,1])
  }
  xdim <- c(min(markerlocs[,1]),max(markerlocs[,1]))
  fromlocs <- total.l / (length(nfrom(ctls))+1)
  tolocs   <- total.l / (length(nto(ctls))+1)

  plot(xdim, c(-1.1, 1.1), t='n', axes = FALSE, xlab = "", ylab = "")
  points(markerlocs, pch=20, cex=(cex/2))
  for(x in 1:nrow(ctls)){ # Plot the ctls
      from <- c(which(nfrom(ctls) %in% ctls[x,1]) * fromlocs,  0.6)
      to   <- c(which(nto(ctls) %in% ctls[x,3]) * tolocs, -0.6)
      via  <- c(markerlocs[ctls[x,2]],  0.0)
    if(!is.na(ctls[x,5])){
      draw.spline(from, to, via, lwd=(ctls[x,4]/5)+1,lty=c(1,2,3)[ctls[x,5]+2], col=col)
    }else{
      cat(paste("Direction of CTL unknown, NA detected:", from[1], via[1], to[1], "\n"))
      draw.spline(from, to, via, lwd=(ctls[x,4]/5)+1,lty=2, col=col)
    }
  } # All done now plot the trait elements
  for(x in 1:length(nfrom(ctls))){
    px <- which(nfrom(ctls) %in% nfrom(ctls)[x]) * fromlocs
    draw.element(px, 0.6, nfrom(ctls)[x], cex=cex, bg.col=bg.col)
  }
  for(x in 1:length(nto(ctls))){
    px <- which(nto(ctls) %in% nto(ctls)[x]) * tolocs
    draw.element(px, -0.6, nto(ctls)[x], cex=cex, bg.col=bg.col)
  }
  box()
  invisible(ctls)
}

# end of ctl.lineplot.R

