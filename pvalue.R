mydata=read.table(commandArgs()[4])
a=1-pchisq(mydata$V1, df= 1)
write.table(a,commandArgs()[5],col.names=FALSE,row.names=FALSE)