library(CausalImpact)

set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)

time.points <- seq.Date(as.Date("2014-01-01"), by = 1, length.out = 100)
data <- zoo(cbind(y, x1), time.points)
head(data)
matplot(data, type = "l")


pre.period <- as.Date(c("2014-01-01", "2014-03-11"))
post.period <- as.Date(c("2014-03-12", "2014-04-10"))

dataTime <- zoo(cbind(causaImp_example_df_td$y,causaImp_example_df_td$x1),as.Date(causaImp_example_df_td$date))
impact <- CausalImpact(dataTime, pre.period, post.period)
plot(impact)



Browse[2]> pre_period()
[1] "2014-01-01" "2014-03-11"
Browse[2]> post_period()
[1] "2014-03-12" "2014-04-10"