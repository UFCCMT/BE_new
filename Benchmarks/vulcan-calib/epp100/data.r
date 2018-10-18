#############################################################
# @author: Nalini Kumar					    #
# @brief:  microkernels or in-situ data parsing & plotting  #
# @place:  CCMT, UF					   #
# @date:   Dec, 2016					    #
#############################################################



###### SET WORKING & OUTPUT DIRECTORIES ######
mainDir <- "/home/legacy/CMT-bone-BE/NGEE/tst-2016/vulcan-calib/epp100"
outDir <- "vul-out-epp100"

#Create a sub directory output if one doesn't alredy exist
dir.create( file.path(mainDir, outDir), showWarnings = TRUE )



###### INPUT CLEANUP ######
# Note: Make sure only the input .csv files are present in the workinng directory
data <- data.frame()
files <- list.files(pattern="*.csv")
data <- do.call( "rbind", lapply(files, function(x) read.csv(x, stringsAsFactors=FALSE, header=FALSE)))

# Read application parameter values, first row
# predefined format is :
# tsteps, elt-size, nelx, nely, nelz, npx, npy, npz, phy-params
temp <- data[seq(1,nrow(data),7), 1:5]
params <- cbind(temp[,1:2], temp[,3]*temp[,4]*temp[,5])
colnames(params) <- c("tsteps", "elt_size", "nelt")

# Peel the rows from the dataframe(df) - data - to create separate dfs
conv <- data[seq(2,nrow(data),7), 2:ncol(data)]
dr   <- data[seq(3,nrow(data),7), 2:ncol(data)]
ds   <- data[seq(4,nrow(data),7), 2:ncol(data)]
dt   <- data[seq(5,nrow(data),7), 2:ncol(data)]
sum  <- data[seq(6,nrow(data),7), 2:ncol(data)]
rk   <- data[seq(7,nrow(data),7), 2:ncol(data)]

# Remove columns with all NAs.
conv <- conv[ , colSums(is.na(conv)) != nrow(conv) ]
dr   <- dr[ , colSums(is.na(dr)) != nrow(dr) ]
ds   <- ds[ , colSums(is.na(ds)) != nrow(ds) ]
dt   <- dt[ , colSums(is.na(dt)) != nrow(dt) ]
sum  <- sum[ , colSums(is.na(sum)) != nrow(sum) ]
rk   <- rk[ , colSums(is.na(rk)) != nrow(rk) ]

conv <- sapply(conv,as.numeric)
dr   <- sapply(dr,as.numeric)
ds   <- sapply(ds,as.numeric)
dt   <- sapply(dt,as.numeric)
sum  <- sapply(sum, as.numeric)
rk   <- sapply(rk,as.numeric)

# Sort the data values and remove the tail from both sides.
# Uncomment the 6 lines below if all sample values are needed.
conv <- t(apply(conv,1,sort))[,6:95]
dr   <- t(apply(dr,1,sort))[,6:95]
ds   <- t(apply(ds,1,sort))[,6:95]
dt   <- t(apply(dt,1,sort))[,6:95]
sum  <- t(apply(sum,1,sort))[,6:95]
rk   <- t(apply(rk,1,sort))[,6:95]



###### STATISTICS ######
conv_mean <- data.frame( conv_mean = rowMeans(conv,na.rm=TRUE))
conv_sd <- data.frame(conv_sd = apply(conv,1,sd,na.rm=TRUE))
conv_d <- cbind(params, conv_mean, conv_sd)

dr_mean <- data.frame( dr_mean = rowMeans(dr,na.rm=TRUE))
dr_sd <- data.frame( dr_sd = apply(dr,1,sd,na.rm=TRUE))
dr_d <- cbind(params, dr_mean, dr_sd)

ds_mean <- data.frame( ds_mean = rowMeans(ds,na.rm=TRUE))
ds_sd <- data.frame( ds_sd = apply(ds,1,sd,na.rm=TRUE))
ds_d <- cbind(params, ds_mean, ds_sd)

dt_mean <- data.frame( dt_mean = rowMeans(dt,na.rm=TRUE))
dt_sd <- data.frame(dt_sd = apply(dt,1,sd,na.rm=TRUE))
dt_d <- cbind(params, dt_mean, dt_sd)

sum_mean <- data.frame( sum_mean = rowMeans(sum,na.rm=TRUE))
sum_sd <- data.frame( sum_sd = apply(sum,1,sd,na.rm=TRUE))
sum_d <- cbind(params, sum_mean, sum_sd)

rk_mean <- data.frame( rk_mean = rowMeans(rk,na.rm=TRUE))
rk_sd <- data.frame( rk_sd = apply(rk,1,sd,na.rm=TRUE))
rk_d <- cbind(params, rk_mean, rk_sd)

means   <- cbind(params, conv_mean, dr_mean, ds_mean, dt_mean, sum_mean, rk_mean)
means <- means[order(means$elt_size),]

sd 	<- cbind(params, conv_sd, dr_sd, ds_sd, dt_sd, sum_sd, rk_sd)
sd <- sd[order(sd$elt_size),]

summary <- cbind(params, conv_mean, conv_sd, dr_mean, dr_sd, ds_mean, ds_sd, dt_mean, dt_sd, sum_mean, sum_sd, rk_mean, rk_sd)
summary <- summary[order(summary$elt_size),]



###### WRITE DATA TO FILE ######
# Sort the data tables based on ascending value of element size.
conv <- cbind(params, conv)  ;  conv <- conv[order(conv$elt_size),]
dr <- cbind(params, dr)  ;  dr <- dr[order(dr$elt_size),]
ds <- cbind(params, ds)  ;  ds <- ds[order(ds$elt_size),]
dt <- cbind(params, dt)  ;  dt <- dt[order(dt$elt_size),]
sum <- cbind(params, sum)  ;  sum <- sum[order(sum$elt_size),]
rk <- cbind(params, rk)  ;  rk <- rk[order(rk$elt_size),]

# .csv file for each individual kernel
write.csv(conv, file.path(mainDir, outDir, "conv.csv"), row.names=FALSE)
write.csv(dr, file.path(mainDir, outDir, "dr.csv"), row.names=FALSE)
write.csv(ds, file.path(mainDir, outDir, "ds.csv"), row.names=FALSE)
write.csv(dt, file.path(mainDir, outDir, "dt.csv"), row.names=FALSE)
write.csv(sum, file.path(mainDir, outDir, "sum.csv"), row.names=FALSE)
write.csv(rk, file.path(mainDir, outDir, "rk.csv"), row.names=FALSE)

# .csv file for statistics of all kernels
write.csv(means, file.path(mainDir, outDir,"means.csv"), row.names=FALSE)
write.csv(sd,	 file.path(mainDir, outDir,"sd.csv"), row.names=FALSE)
write.csv(summary, file.path(mainDir, outDir, "summary.csv"), row.names=FALSE)



###### PLOTS ######

# Plot MEANS of samples for all microkernels.
#	X-axis: element size
#	Y-axis: mean execution time per timestep
#pdf("vulcan-calib-epp100.pdf")
jpeg(file="vulcan-calib-epp100-means.jpg", quality=100)

par( mfrow=c(3,2) )
plot(means$dr_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean exectuion time for \"Dr\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")
plot(means$ds_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean execution time for \"Ds\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")
plot(means$dt_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean execution time for \"Dt\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")
plot(means$conv_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean execution time for \"Conv\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")
plot(means$sum_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean execution time for \"Sum\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")
plot(means$rk_mean, type="p", xlab= "element size", ylab= "avg. execution time/timestep", main= "Mean execution time for \"RK\" - Vulcan", pch = 19, cex =0.9, frame.plot=1,col="blue")

dev.off()


# Plot STANDARD DEVIATION for all microkernels.
#       X-axis: element size
#       Y-axis: mean execution time per timestep
#pdf("vulcan-calib-epp1.pdf")
jpeg(file="vulcan-calib-epp100-sd.jpg", quality=100)

par( mfrow=c(3,2) )
plot(sd$dr_sd, type="p", xlab= "element size",  main= "Std. dev  for \"Dr\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")
plot(sd$ds_sd, type="p", xlab= "element size",  main= "Std. dev for \"Ds\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")
plot(sd$dt_sd, type="p", xlab= "element size",  main= "Std. dev for \"Dt\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")
plot(sd$conv_sd, type="p", xlab= "element size", main= "Std. dev for \"Conv\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")
plot(sd$sum_sd, type="p", xlab= "element size",  main= "Std. dev for \"Sum\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")
plot(sd$rk_sd, type="p", xlab= "element size",  main= "Std. dev for \"RK\" - Vulcan", pch = 19, cex =1.2, frame.plot=1,col="red")

dev.off()
