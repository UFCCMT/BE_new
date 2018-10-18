
#get current directory
mydir<-getwd()

#set working directory
setwd("/home/legacy/CMT-bone-BE/NGEE/CMT-bone-BE/mpi/data_8x8x8")

#Combine all *.out files into one data frame
data <- data.frame()
files <- list.files(pattern="*.out")
data <- do.call( "rbind", lapply(files, function(x) read.csv(x, stringsAsFactors=FALSE, header=FALSE)))

#split into separate data frames for 
#	1) input parameter values
#	2) log of every timestep
#	3) average caluculated by the program
params <- data[seq(1,nrow(data),3), 1:9]
tsteps <- data[seq(2,nrow(data),3), ]
temp_average <- data[seq(3,nrow(data),3), 1]
avg <- gsub( "Average time: ", "\\1", temp_average[1] )
avg <- sapply(avg, as.numeric)
tsteps <- sapply(tsteps, as.numeric)

# for generic string replacement
# avg <- gsub( ".*: ()", "\\1", temp_average[,1]  )

#generate scatter plots from measurements
pdf("multiple-runs-8x8x8.pdf")
par( mfrow=c(4,3) )

plot( tsteps[2,], type="p", main="Run 1", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[3,], type="p", main="Run 2", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[4,], type="p", main="Run 3", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[5,], type="p", main="Run 4", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[6,], type="p", main="Run 5", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[7,], type="p", main="Run 6", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[8,], type="p", main="Run 7", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[9,], type="p", main="Run 8", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[10,], type="p", main="Run 9", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )
plot( tsteps[1,], type="p", main="Run 10", xaxt="n", xlab="", ylab="execution time(sec)", pch=1, cex=0.9, frame.plot=1, col="blue" )

dev.off()



