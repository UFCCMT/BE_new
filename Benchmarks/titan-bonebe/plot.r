setwd("/home/legacy/sys-data/sim-validation-titan-d")
data <- read.csv("titan-val.csv", header=TRUE)

#### RGL PLOT ####
library("rgl")
attach(data)
open3d()
plot3d(elt_size, np, mean, 
#col=rainbow(6),
col="blue"
# type="s", size=1, 
type="h", pch=16, 
axes=1, box=FALSE,
xlab="element size", 
ylab="MPI ranks (no. of processor cores)", 
zlab="average execution time / timestep",
main="Titan BE simulations")


#### SCATTER PLOT 3D ####
library(scatterplot3d)
attach(data)
#jpeg(file="titan-graph.jpg", quality=100)
s3d <- scatterplot3d(elt_size, np, mean,
type="h", pch=16, 
col=rgb(0,100,0,50,imaxColorValue=255),
#highlight.3d=TRUE, 
axis=1, box=0, angle=225,
xlab="element size", 
ylab="MPI ranks (no. of processor cores)", 
zlab='average execution time / timestep(sec)', 
main="Titan BE simulations") 


s3d$plane3d(2,512,0, "solid", col="lightblue")
s3d$plane3d(4,512,0, "solid", col="lightblue")
s3d$plane3d(6,512,0, "solid", col="lightblue")
s3d$plane3d(8,512,0, "solid", col="lightblue")
s3d$plane3d(10,512,0, "solid", col="lightblue")
s3d$plane3d(12,512,0, "solid", col="lightblue")
s3d$plane3d(14,512,0, "solid", col="lightblue")
s3d$plane3d(16,512,0, "solid", col="lightblue")

dev.off()



