source("librerias.R")
## Start a local cluster with 5GB RAM
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE, 
                    Xmx = '5g')

train = read.csv('datos/train.csv',header=TRUE,stringsAsFactors = T)
test = read.csv('datos/test.csv',header=TRUE,stringsAsFactors = T)
str(train)
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

log_wagp_dl <- h2o.deeplearning(x = 1:(dim(train)[2]-1),  nfolds = 3,hidden = c(100,100),epochs = 800,
                                y = dim(train)[2],
                                data = dat_h2o,
                                key  = "log_wagp_dl",
                                classification = FALSE)
log_wagp_dl



h2o.mse(h2o.predict(log_wagp_glm_best, adult_2013_test),
        actual_log_wagp)
h2o.mse(h2o.predict(log_wagp_gbm_best, adult_2013_test),
        actual_log_wagp)
h2o.mse(h2o.predict(log_wagp_forest,   adult_2013_test),
        actual_log_wagp)
h2o.mse(h2o.predict(log_wagp_dl,       adult_2013_test),
        actual_log_wagp)
