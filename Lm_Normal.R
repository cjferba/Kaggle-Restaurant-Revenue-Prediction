Train<-read.csv("train.csv")
Test<-read.csv("test.csv")

summary(Train)
str(Test)
names(Test)<-names(Train)[1:42]
fit <- glm(revenue ~ ., data=Train[,-c(2,3,4,5)])
resul<- predict.glm(fit,newdata = Test[,-c(2,3,4,5)])

salida<-cbind(Id=Test[,1],Prediction=resul)

write.csv(salida, file = "LmNormal.csv", row.names = FALSE)

model <- glm(P37~., data=Train[,-2])
predict(model, Test[,-2], type="response",na.omit)


summary(Test)
unique(Test)
