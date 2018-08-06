library(pa)
data <- year
names(data)
data$date

data(jan)
jan <- jan
rb.single <- regress(jan, date.var = "date", ret.var = "return",reg.var = c("sector", "growth", "size"), benchmark.weight = "benchmark",portfolio.weight = "portfolio")
summary(rb.single)

returns(rb.single, var = "sector")

plot(rb.single, var = "sector", type = "exposure")


returns(rb.single)

attach(ex)
ex$Portfolio


write.csv(ex,"C:/Users/debapriyag/Desktop/file.csv")


exposure(object = "regression")
signature(x = "regression", y = "missing")














