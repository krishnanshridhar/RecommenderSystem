library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme=shinytheme("united"),shinythemes::themeSelector(),
                  titlePanel(tags$h1(tags$i(tags$b(("Trolley Prediciton Support System"))))),
                  
                  sidebarPanel( 
                    conditionalPanel(
                      tags$head(tags$style(type="text/css", "
                                           #loadmessage {
                                           position: relative;
                                           top: 0px;
                                           left: 0px;
                                           width: 100%;
                                           padding: 5px 0px 5px 0px;
                                           text-align: center;
                                           font-weight: bold;
                                           font-size: 100%;
                                           color: #000000;
                                           border:1px solid black;
                                           background-color: #green;
                                           z-index: 105;
                                           }")),
    uiOutput("companyName1"),
    uiOutput("storesNames1"),
    uiOutput("bayName1"),
    selectInput("time_of_the_day","Quater of the day",choices = c("1","2","3","4")),
    dateInput("date","Date",format="dd/mm/yyyy",min = Sys.Date()),
    tags$div(id="buttonDiv",tags$style("#buttonDiv{text-align:center;margin-left:3%;}"),actionButton("action","Start Engine",class = "btn-primary")),
    
    p(id="helpText",
      tags$style("#helpText{text-align:center;font-size:10px'}"),"Click Start button once to know the prediction") 
                      )), 
    mainPanel(
       
      tabsetPanel(type="tab", 
                   tabPanel("Knowledge",tags$div(id="tab4",tags$style("#tab4{border:1px solid darkgrey;border-radius: 15px;text-align:center;margin-left:1%;margin-top:1%; display: inline-block;   padding-bottom: 5%;
                                                                     width: 70%;background-color:lavender;height:43em;}"), 
                                                (tags$ul(
                                                  tags$p(id="p1",tags$style("#p1{font-size:20px;margin-top:5%;    position: inherit;
                                                                            align-items: center;
                                                                            margin-top: 10%;align:centre;}"),"Maximum Capacity of this Bay "),
                                                  tags$li( id="list1", tags$style(type="text/css", "#list1{ padding-top:1.5%;font-family: sans-serif;margin-left: 40%; height: 50px;border-radius:11px;border: 2px solid #e3e3e3;background-color:#f5f5f5 ;width: 20%; text-align:center; font-size: 20px; display: block;}"),(textOutput("BayCapacity"))), 
                                                  tags$p(id="p2",tags$style("#p2{font-size:20px;margin-top:3%;}"),"Recommended Bay Stock "),
                                                  tags$li( id="Stock",tags$style(type="text/css", "#Stock{padding-top:1.5%;border-radius:11px;margin-left: 40%;font-family: sans-serif; height: 50px;border: 2px solid #e3e3e3;background-color:#f5f5f5 ;width: 20%; text-align:center; font-size: 20px; display: block;}"),(textOutput("pred"))),
                                                  tags$p(id="p3",tags$style("#p3{font-size:20px;margin-top:3%;}"),"Recommended Percentage Stock"),
                                                  tags$li( id="percentage_Stock1",tags$style(type="text/css", "#percentage_Stock1{padding-top:1.5%;border-radius:11px;font-family: sans-serif;;margin-left: 40%; height: 50px;border: 2px solid #e3e3e3;background-color:#f5f5f5 ;width: 20%; text-align:center; font-size: 20px; display: block;}"),(textOutput("percentage"))),
                                                  tags$li( id="knowledge",(tableOutput("tab1"))),
                                                  tags$p(id="p4",tags$style("#p4{font-size:20px;margin-top:3%;}"),"Stock Available in Each Bay"),
                                                  tags$li( id="baystock",tags$style(type="text/css", "#baystock{padding-top:1.5%;border-radius:11px;font-family: sans-serif;;margin-left: 40%; height: 6.5em;border: 2px solid #e3e3e3;background-color:#f5f5f5 ;width: 20%; text-align:center; font-size: 20px; display: block;}"),(tableOutput("cons")))
                                                                                                                                                                                                                                                                                                               
                                                  ))
                                                
                                                )) 
                  
                  
                  
                  )
      
                  )
))