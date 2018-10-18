# Set working directory
setwd("/home/legacy/CMT-bone-BE/NGEE/tst-2016/cab-bonebe")


###### INPUT DATA ######
# Combine all *.csv files and then split them into 3 separate data frames
data <- data.frame()
files <- list.files(pattern="*.csv")
data <- do.call( "rbind", lapply(files, function(x) read.csv(x, stringsAsFactors=FALSE, header=FALSE)))

params <- data[seq(1,nrow(data),3), 1:9]  # 1) input parameter values
colnames(params) <- c("tsteps", "elt_size", "nelt_x", "nelt_y", "nelt_z", "npx", "npy", "npz", "phy_params")

tsteps <- data[seq(2,nrow(data),3), ]	  # 2) log of every timestep
tsteps <- sapply(tsteps, as.numeric)

i_temp_avg <- data[seq(3,nrow(data),3), 1]  # 3) average caluculated by the program
i_mean <- data.frame(gsub( "Average time: ", "\\1", i_temp_avg )) # for generic string replacement: avg <- gsub( ".*: ()", "\\1", i_temp_avg[,1]  )
#i_mean <- sapply(i_mean, as.numeric)
colnames(i_mean) <- c("sys_mean")


###### STATISTICS ######
# Calculate mean and standard deviation for the values input values.
# Write to an output file.
d_mean <- data.frame(rowMeans(tsteps, na.rm=TRUE)) # Mean
colnames(d_mean) <- c("mean")
#d_sd = data.frame(apply(tsteps, 1, sd, na.rm=TRUE))  # Standard deviation
#colnames(d_sd) <- ("sd")

summary <- cbind(params, d_mean)#, d_sd)
write.csv(summary, "summary-cab-machine.csv", row.names=FALSE)


#jpeg(file="titan-graph.jpg", quality=100)
#s3d <- scatterplot3d(elt_size, np, mean, main="Titan BE simulations", type="h", highlight.3d=TRUE, pch=16, xlab="element size", ylab="MPI ranks (no. of processor cores)", zlab='average execution time / timestep(sec)', axis=1, box=0, angle=225)

#s3d$plane3d(2,512,0, "solid", col="lightblue")
#s3d$plane3d(4,512,0, "solid", col="lightblue")
#s3d$plane3d(6,512,0, "solid", col="lightblue")
#s3d$plane3d(8,512,0, "solid", col="lightblue")
#s3d$plane3d(10,512,0, "solid", col="lightblue")
#s3d$plane3d(12,512,0, "solid", col="lightblue")
#s3d$plane3d(14,512,0, "solid", col="lightblue")
#s3d$plane3d(16,512,0, "solid", col="lightblue")
#dev.off()



#sd_data <- as.data.frame( cbind( sd(d[,"5"]), sd(d[,"6"]), sd(d[,"7"]), sd(d[,"8"]), sd(d[,"9"]), sd(d[,"10"]) ) )   # Standard deviation 
#colnames(sd_data) <- c("5","6","7","8","9","10")
#sem_data <- sd_data/sqrt(nrow(d)) # Standard error of mean
#ci <- rbind(mean_data-2*sem_data, mean_data+2*sem_data) # 95% CI of the mean

#summary <- rbind(mean_data, sd_data, sem_data, ci, make.row.names=FALSE)
#library(data.table)
#setattr(summary, "row.names", c("mean","sd","sem","ci-down","ci-up"))
#write.csv(summary, "summary.csv", row.names=TRUE)


###### PLOTS ######
# Boxplot
#boxplot(d, xlab="element size", ylab="execution time per timestep")

#plot(mean_data[1,], type="o", main="Mean execution time", xlab="element size", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue")


# Scatter plots for all measurements
#pdf("cab-mean-1000.pdf")
#par( mfrow=c(3,2) )

#plot( data[,1], type="p", main="elt_size = 5", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
#plot( data[,2], type="p", main="elt_size = 6", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
#plot( data[,3], type="p", main="elt_size = 7", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
#plot( data[,4], type="p", main="elt_size = 8", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
#plot( data[,5], type="p", main="elt_size = 9", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
#plot( data[,6], type="p", main="elt_size = 10", xaxt="n", xlab="", ylab="mean execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )

#dev.off()

