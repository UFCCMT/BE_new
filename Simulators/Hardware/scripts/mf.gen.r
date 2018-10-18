wd <- "C:/Users/Krishna/Desktop/Research/BEO_TILE/memory files/8x8 for threads 0,1,6,7/appBEOs"

in.file <- "appBEO_iROM_0.txt"
out.file <- "appBEO_iROM_0.mif"


setwd(wd)

getwd()

mif.gen <- function(in.file, out.file){
  require(compositions)
  op.w <- 4
  tag.w <- 6
  did.w <- 10
  stime.w <- 12
  ntime.w <- 16
  advt.w <- 28
  inst.w <- 32
  depth <- 256

  mif <- c(paste("WIDTH=",inst.w,";",sep=""),paste("DEPTH=",depth,";",sep=""), "", "ADDRESS_RADIX=UNS;", "DATA_RADIX=BIN;", "",   "CONTENT BEGIN")
  ln.n <- 0
  for( inst in readLines(in.file)){
    s.inst <- strsplit(inst," ")
    s.inst <- s.inst[[1]]
    if(identical(s.inst[1],"advt") & (length(s.inst) == 2)){
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(1,mb=(op.w-1)) , binary(as.numeric(s.inst[2]),mb=(advt.w-1)), ";", sep="" ))
      ln.n <- ln.n + 1
    }else if(identical(s.inst[1],"send") & (length(s.inst) == 5)){
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(8,mb=(op.w-1)) , binary(as.numeric(s.inst[2]),mb=(tag.w-1)) , binary(as.numeric(s.inst[3]),mb=(did.w-1)) , binary(as.numeric(s.inst[4]),mb=(stime.w-1)), ";", sep="" ))
      ln.n <- ln.n + 1
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(0,mb=(inst.w-ntime.w-1)) , binary(as.numeric(s.inst[5]),mb=(ntime.w-1)), ";", sep="" ))
      ln.n <- ln.n + 1
    }else if(identical(s.inst[1],"recv") & (length(s.inst) == 2)){
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(4,mb=(op.w-1)) , binary(as.numeric(s.inst[2]),mb=(tag.w-1)) , binary(0,mb=(inst.w-op.w-tag.w-1)), ";" , sep="" ))
      ln.n <- ln.n + 1
    }else if(identical(s.inst[1],"noop") & (length(s.inst) == 1)){
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(0,mb=(inst.w-1)), ";", sep=""))
      ln.n <- ln.n + 1
    }else if(identical(s.inst[1],"done") & (length(s.inst) == 1)){
      mif <- c(mif, paste("  ", ln.n, "   :   ", binary(-1,mb=(op.w-1)) , binary(0,mb=(advt.w-1)), ";", sep="" ))
      ln.n <- ln.n + 1
    }else{  
      stop(inst)
    }
  }
  for(i in ln.n:(depth-1)){
    mif <- c(mif, paste("  ", ln.n, "   :   ", binary(0,mb=(inst.w-1)), ";", sep="" ))
    ln.n <- ln.n + 1
  }    
  mif <- c(mif, "END;")
  writeLines(mif,out.file)
}


mif.gen("appBEO_iROM_0.txt","appBEO_iROM_0.mif")
