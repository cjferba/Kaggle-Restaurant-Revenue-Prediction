
source("librerias.R")
## Start a local cluster with 5GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE, 
                    Xmx = '5g')

train = read.csv('train.csv',header=TRUE,stringsAsFactors = T)
test = read.csv('test.csv',header=TRUE,stringsAsFactors = T)
names(test)<-names(train[,1:(dim(train)[2]-1)])

train$day<-as.factor(day(as.POSIXlt(train$Open.Date, format="%m/%d/%Y")))
train$month<-as.factor(month(as.POSIXlt(train$Open.Date, format="%m/%d/%Y")))
train$year<-as.factor(year(as.POSIXlt(train$Open.Date, format="%m/%d/%Y")))

test$day<-as.factor(day(as.POSIXlt(test$Open.Date, format="%m/%d/%Y")))
test$month<-as.factor(month(as.POSIXlt(test$Open.Date, format="%m/%d/%Y")))
test$year<-as.factor(year(as.POSIXlt(test$Open.Date, format="%m/%d/%Y")))

train_cols<-train[,c(3:42,44:46)]
labels<-as.matrix(train[,43])
testdata<-test[,3:45]

train_cols <- data.frame(lapply(train_cols,as.numeric))
testdata<-data.frame(lapply(testdata,as.numeric))

str(train_cols)
str(testdata)
train = train[,-c(1,2)]
test = test[,-c(1,2)]
#train<-train[,c(names,"target")]
#test = test[,names]

## Convert datos into H2O
dat_h2o <- as.h2o(localH2O, train, key = 'dat')
testh2o <- as.h2o(localH2O, test, key = 'test')
## Import MNIST CSV as H2O
#dat_h2o <- h2o.importFile(localH2O, path = ".../mnist_train.csv")

#lasagne + nolearn

str(train)
train<-cbind(train_cols,labels)
log_wagp_forest <- h2o.randomForest(x = 1:(dim(train)[2]-1),y=dim(train)[2],
                                    mtries = -1,importance = T,
                                    nfolds = 4,y = train, data = dat_h2o,
                                    key  = "log_wagp_forest",
                                    classification = FALSE,
                                    depth = 10,
                                    ntree = 400,
                                   # validation = adult_2013_test,
                                    seed = 8675309,
                                    type = "BigData")
log_wagp_forest

h2o.mse(h2o.predict(log_wagp_glm_best, adult_2013_test),
        actual_log_wagp)
h2o.mse(h2o.predict(log_wagp_gbm_best, adult_2013_test),
        actual_log_wagp)
h2o.mse(h2o.predict(log_wagp_forest,   adult_2013_test),
        actual_log_wagp)