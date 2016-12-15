  library(e1071)
library(ggplot2)
library(GGally)
library(dplyr)
library(tree)
library(rpart)
library(rpart.plot)
library(lubridate)
library(shiny)
inputDataset1<- read.csv('data_cons.csv')
shinyServer (function(input,output){
  inputDataset <- read.csv('DataSetSummary.csv')
  trainset <- read.csv('data_cons.csv')
  testset <- read.csv('test.csv',header = T,stringsAsFactors = F)
  AttributesIntrainset<- c()
  for(i in 1:dim(trainset)[2])
  {
    if(is.numeric(trainset[,i])|| is.integer(trainset[,i]))
    {
      AttributesIntrainset[i]=T 
    }
    else
    {
      AttributesIntrainset[i]=F
    }
  }
  updatedDatasetWithOnlyNumericValues <- na.omit(trainset[,AttributesIntrainset])
  ggplot(updatedDatasetWithOnlyNumericValues, aes(x=Used_Items/Bay_capacity)) + geom_histogram()
  correlationMatrix <- c()
  for(i in 1:dim(updatedDatasetWithOnlyNumericValues)[2])
  {
    correlationMatrix[i] <- cor(updatedDatasetWithOnlyNumericValues[,i],updatedDatasetWithOnlyNumericValues[,'Used_Items'])
  }
  
  plot(correlationMatrix)
  set.seed(2)
  train <- sample(dim(updatedDatasetWithOnlyNumericValues)[1],
                  dim(updatedDatasetWithOnlyNumericValues)[1]*0.80)
  temp_train <- updatedDatasetWithOnlyNumericValues[train,]
  temp_test <- updatedDatasetWithOnlyNumericValues[-train,]
  lmfit = lm(Used_Items~ Quarter_of_the_day  + holiday +
               company_id+	store_id+	Bay_id ,data=temp_train)
  model <- svm(Used_Items~ Quarter_of_the_day  + holiday +
                 company_id+	store_id+	Bay_id , temp_train)
  tuneResult <- tune(svm, Used_Items~ Quarter_of_the_day  + holiday +
                       company_id+	store_id+	Bay_id,  data = temp_train,
                     ranges = list(epsilon = 0.9, cost = 128))
  tunedModel <- tuneResult$best.model 
  Company <- inputDataset[row.names(unique(inputDataset[,c("Company.id","Company.name")])),]
  companyName <- list(Company$Company.name)
  output$companyName1 <- renderUI({
    selectInput("company_list_id", "Company Name", as.list(companyName))
  })
  
  stores <- inputDataset[row.names(unique(inputDataset[,c("Store.id","Company.id")])),]
  storesNames <-stores$Store.name
  print (storesNames)
  
  output$storesNames1 <- renderUI({
    selectInput("store_list_id", "Store Name", storesNames)
    
    
  })
  
  baysSummary <- inputDataset[inputDataset$Store.id == "1",]
  bays <- baysSummary[row.names(unique(baysSummary[,c("Bay.id","Store.id")])),]
  bayNames <- (bays$Bay.name)
  print (bayNames)
  output$bayName1 <- renderUI({
    selectInput("bay_list_id", "Bay Name", (bayNames))
  })
  
  output$tab<-renderText({
    if(input$action==0)
      return()
    else
      paste("Hey krishnan ! ","\n",
            "You have selected company  - ",  '\n',input$select_company,
            " Store -  ",input$select_store,"Bay Number- " ,input$bay_number, "Date", input$date,"Time of the day : ",input$time_of_the_day)
  })    
  
  output$tab1<-renderText({
    print(input$company_list_id)
    CompanySubset <- subset(inputDataset,inputDataset$Company.name==input$company_list_id)
    CompanyUnique<- CompanySubset [row.names(unique(CompanySubset [,c("Company.id","Company.id")])),]
    CompanyId <-CompanyUnique$Company.id 
    
    StoreSubset <- subset(inputDataset,inputDataset$Store.name==input$store_list_id)
    StoreUnique<- StoreSubset [row.names(unique(StoreSubset [,c("Company.id","Store.id")])),]
    StoreId <- StoreUnique$Store.id 
    print(input$bay_list_id)
    StoreBaySubset <- subset(inputDataset,inputDataset$Store.name==input$store_list_id)
    print(StoreBaySubset)
    BaySubset <- subset(StoreBaySubset,StoreBaySubset$Bay.name==input$bay_list_id)
    print(BaySubset)
    BayId<-BaySubset$Bay.id
    BayCapacity <- BaySubset$Capacity
    print(BayCapacity)
    testset$company_id = CompanyId
    testset$store_id = StoreId
    testset$Bay_id = BayId
    if(StoreId>1){
      testset$Bay_id = BayId+(StoreId*4)
    }
    testset$Bay_id = BayId
    print(testset$Bay_id)
    testset$Quarter_of_the_day=as.numeric(input$time_of_the_day)
    holiday<- wday(input$date, label = FALSE)
    testset$holiday=0
    if(holiday == 7){
      testset$holiday=1
    }
    if(holiday == 1){
      testset$holiday=1
    }
    testset$Quarter_of_the_day=as.numeric(input$time_of_the_day)
    print(testset$company_id )
    print(testset$store_id )
    print(testset$Bay_id)
    print(testset$Quarter_of_the_day)
    pred <- predict(lmfit,testset)
    print(pred) 
    
    
    
    
    
    predictedUsed_Items <- predict(tunedModel, testset)
     
    
    BaySubset <- subset(StoreBaySubset,StoreBaySubset$Bay.name==input$bay_list_id)
    print(BaySubset)
    BayId<-BaySubset$Bay.id
    BayCapacity <- BaySubset$Capacity
    print( StoreId)
    localVar<- testset$store_id
    localVar<- localVar-1
    print( localVar)
    if(testset$store_id >1){
      testset$Bay_id = 1+(localVar *4)
    }else{
      testset$Bay_id = 1
    }
    print( testset$Bay_id)
    print( testset)
    predicted1 <- predict(tunedModel, testset)
    BaySubset1 <- subset(StoreBaySubset,StoreBaySubset$Bay.id==testset$Bay_id)
    BayCapacity1 <- BaySubset1$Capacity
   
    if(testset$store_id >1){
      testset$Bay_id = 2+(localVar *4)
    }else{
      testset$Bay_id = 2
    }
    print( testset$Bay_id)
    predicted2 <- predict(tunedModel, testset)
    BaySubset2 <- subset(StoreBaySubset,StoreBaySubset$Bay.id==testset$Bay_id)
    BayCapacity2 <- BaySubset2$Capacity
    if(testset$store_id >1){
      testset$Bay_id = 3+(localVar *4)
    }else{
      testset$Bay_id = 3
    }
    print('test bay 3 ', testset$Bay_id)
    predicted3 <- predict(tunedModel, testset)
    BaySubset3 <- subset(StoreBaySubset,StoreBaySubset$Bay.id==testset$Bay_id)
    BayCapacity3 <- BaySubset3$Capacity
    if(testset$store_id >1){
      testset$Bay_id = 4+(localVar *4)
    }else{
      testset$Bay_id = 4
    }
    print('test bay 4', testset$Bay_id)
    predicted4 <- predict(tunedModel, testset)
    BaySubset4 <- subset(StoreBaySubset,StoreBaySubset$Bay.id==testset$Bay_id)
    BayCapacity4 <- BaySubset4$Capacity
    output$cons<-renderText({
      paste('Bay1',(BayCapacity1 - round(predicted1)),
            'Bay2',(BayCapacity2 - round(predicted2)),
            'Bay3',(BayCapacity3 - round(predicted3)),
            'Bay4',(BayCapacity4 - round(predicted4)))
    }) 
      
    
    output$hist<-renderPlot({
       barplot(trainset[,1],  
              ylab="Y Axis",
              xlab="X AXis"
      )
    })
      
     if(input$action==0)
      return()
    else
      output$pred<-renderText({
        paste(round(predictedUsed_Items))
      }) 
    output$BayCapacity<-
      output$BayCapacity<-renderText({
        paste(BayCapacity)
      }) 
    output$percentage<-renderText({
      
      paste((round(((round(predictedUsed_Items))/BayCapacity)*100 )),"%")
    }) 
    
    output$phonePlot <- renderPlot({
      
      
      barplot(inputDataset[,'Capacity' ] , 
              main='Bay-wise Capacity',
              ylab="Stock Count",
              xlab="Bays" )
    }) 
     
    paste("Bay Capacity = Maximum number of trolleys supported in the bay",HTML("</br>"),"Bay Stock = number of trolley recommended in this bay",HTML("</br>"),"Bay Percentage = percentage of trolleys recommended")
    #predictedUsed_Items, predict(lmfit,testset) 
  }) 
  
})