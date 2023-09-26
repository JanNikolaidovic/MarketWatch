getwd()
setwd('C:/Users/ioann/Desktop')

#putting the necessary libraries to be loaded, in a variable
packages<- c('forecast','tseries','ggplot2')

#iterating over these and in case they are not already in R, download them and load them
for (pkg in packages){
  if(!require(pkg,character.only = T)){
    install.packages(pkg,dependencies=T)
    library(pkg,character.only = T)
  }
}

#reading the dataset derived from yahoo finance
data <- read.csv("C:/Users/ioann/Desktop/MarketWatch/TSLA1.csv")

#visualising the first 10 observations of the data, corresponding the first two weeks 
head(data, n = 10) 

#extracting the 'adj.close' column as a Time Series Object. We could also pull the 'close' value...
ts_data <- ts(data$Adj.Close,frequency = 252)  #frequency assumes everyday data except weekends. 
#If hypothetically the stock market was open everyday within the year, this value would be 365!


#plotting the Time Series Data
plot(ts_data, main= 'TSLA Stock (Adj.Close) from 2015 to 2023', ylab = 'price',xlab = 'time')

#In order to identify the proper AR and MA order (parameters), we need to calculate ACF and PACF.

#ACF plot (Auto-Correlation Function)
acf(ts_data, main = 'ACF of TSLA Stock')  #No clear pattern. It's tricky , we can compare models(AIC or BIC) starting with lower values such as 1,2...


#PACF plot (Partial Auto-Correlation Function)
pacf(ts_data, main= 'PACF of TSLA Stock') # possible values 1, 5 , 8 or 10...


#Running the ARIMA model with order 5,1,1
model <- arima(ts_data, order= c(5,1,1))
summary(model)

#forecast future values , next 30 days...
forecast_res <- forecast(model, h=30)
plot(forecast_res)


#we can also determine the p,d,q order values from he ACF and PACF plots, we can use auto.arima
auto_model <- auto.arima(ts_data)
summary(auto_model)
forecast_auto <- forecast(auto_model, h=30)
plot(forecast_auto)


#what if we split the data and check the accuracy on unseed data ? (last 60 days)
train_end <- length(ts_data) - 60
train_data <- ts_data[1:train_end]
test_data <- ts_data[(train_end+1):length(ts_data)]

#run the arima on train...
set.seed(555)
model <- arima(test_data, order= c(10,1,2))  # Or use your chosen order, e.g., arima(train_data, order=c(1,1,1))

forecast_results <- forecast(model, h=60)

accuracy(forecast_results, test_data) #are we accurate?    


# extracting the appropriate time index..
time_index <- time(test_data)

# plotting the last 60 points from the test_data with the proper x axis labels
plot(time_index, test_data, type="l", xlim=c(min(time_index), max(time_index)), ylim=c(min(test_data), max(test_data)), main="Actual vs Forecasted for Last 60 Points", xlab="Time", ylab="Value")
lines(time_index, forecast_results$mean, col="red")
legend("topright", legend=c("Actual", "Forecasted"), col=c("black", "red"), lty=1)
