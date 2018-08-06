library(rpart)
data <- (kyphosis)
fit <- rpart(Kyphosis ~ Age + Number + Start,method="class", data=kyphosis)
fit
printcp(fit)
plotcp(fit)
summary(fit)
plot(fit, uniform=TRUE, main="")
text(fit, use.n=TRUE, all=TRUE, cex=.8)
post(fit, file = "", main = "xyz")   

