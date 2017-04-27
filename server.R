
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(emoGG)

BMI <- 0.00
anyCompl <- 0.00

### Regression coefficents
sexFactor           <-  -0.0242882
raceFactor          <-   0.0596692
ageFactor           <-   0.0028318
GastRxnFactor       <-  -0.5105275
ColonRxnFactor      <-  -0.8071903
CancerGIFactor      <-   0.0870107
FunctionalFactor    <-  -0.5353748
asaclassFactor      <-   0.4420653  
steroidFactor       <-   0.4215457   
ascitesFactor       <-   0.7761558  
SepticFactor        <-   0.7766535  
ventilarFactor      <-   0.904599   
DMallFactor         <-   0.0697649  
hypermedFactor      <-   0.0406726   
hxchfFactor         <-   0.2994934
SOBFactor           <-   0.2186209   
smokerFactor        <-   0.1309884   
hxcopdFactor        <-   0.2158972   
dialysisFactor      <-   0.1193262     
renafailFactor      <-   0.3735297 
BMIFactor           <-   0.0094137
consFactor          <-  -1.761664 

shinyServer(function(input, output, session) {

  #Switches from the quertionaire view to the data view
  ## when the submit button is pressed
  observeEvent(input$Submit, {
      updateTabsetPanel(session, "tab", 'dataViewer')
  
  #Create the risk plot graph
  output$riskPlot <- renderPlot ({
    ### Dummy data graph
    barplot(VADeaths,
            angle = 15+10*1:5,
            density = 20,
            col = "black",
            legend = rownames(VADeaths))
    title(main = list("Some Data...", font = 4))
  })
  
  ###Calculate BMI
  if(is.numeric(input$BMI))
    BMI <- as.numeric(input$BMI)
  else
    BMI <- calcBMI(weight=as.numeric(input$weight), height=as.numeric(input$height))
  
  ###Calculate the Major Complication Risk
  anyCompl <- 0.00  #Make sure we're starting from 0
  anyCompl <- sexFactor*switch(input$GenderButton, "Male" = 1, "Female" = 0)
  anyCompl <- anyCompl + raceFactor*switch(input$RaceButton, "White" = 1, "Non-White" = 0, 1)
  anyCompl <- anyCompl + ageFactor*input$PtAge
  anyCompl <- anyCompl + switch(input$SurgeryTypeButton,
                                "Pancreas" = 0,
                                "Stomach" = GastRxnFactor,
                                "Colon" = ColonRxnFactor)
  anyCompl <- anyCompl + switch(input$SurgeryTypeButton,
                                "Pancreas" = 0,
                                "Stomach" = -0.5105275,
                                "Colon" = -0.8071903, 0)
  anyCompl <- anyCompl + FunctionalFactor*switch(input$FunctionalStatus,
                                                 "Totally Depdendent" = 0,
                                                 "Partially Dependent" = 1,
                                                 "Fully Independent" = 2, 2)
  anyCompl <- anyCompl + CancerGIFactor*switch(input$GICancer,
                                               "Cancer Surgery" = 1,
                                               "Benign disease" = 0, 0)
  anyCompl <- anyCompl + asaclassFactor*switch(input$OtherMedical, "Totally Healthy" = 1,
                                               "Mild diseases" = 2,
                                               "Severe diseases" = 3,
                                               "Near death" = 4, 1)
  anyCompl <- anyCompl + steroidFactor*switch(input$steroids,
                                              "Yes" = 1,
                                              "No" = 0, 0)
  anyCompl <- anyCompl + ascitesFactor*switch(input$ascites,
                                              "Yes" = 1,
                                              "No" = 0, 0)
  anyCompl <- anyCompl + SepticFactor*switch(input$septic, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + ventilarFactor*switch(input$vent, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + DMallFactor*switch(input$DMall, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + hypermedFactor*switch(input$HTNMeds, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + hxchfFactor*switch(input$HxCHF, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + SOBFactor*switch(input$SOB, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + smokerFactor*switch(input$Smoker, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + hxcopdFactor*switch(input$HxCOPD, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + dialysisFactor*switch(input$Dialysis, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + renafailFactor*switch(input$RenalFailure, "Yes" = 1, "No" = 0, 0)
  anyCompl <- anyCompl + BMIFactor*BMI
  anyCompl <- anyCompl + consFactor

  ###BMI valuebox - Setup
  output$BMIBox <- renderValueBox({
    valueBox(formatC(BMI, digits = 1, format = "f"), subtitle = "BMI",
             icon = icon("area-chart"),
             color = if (BMI > 25) "red" else "aqua"
    )
  })
  #Update the text in the BMI text field
  updateTextInput(session, 'BMI', value = formatC(BMI, digits = 2, format = "f"))
  
  ###MAJOR RISK COMPLICATION BOX
  output$anyComplBox <- renderValueBox({
    valueBox(
      paste0(formatC(exp(anyCompl)*100, digits = 1, format = "f"), "%"),
      "Major Complication Risk",
      icon = icon("plus-square"),
      color = "purple"
    )
  })
  
  ###SOME OTHER INFO
  output$generic1 <- renderValueBox({
    valueBox(
      paste0(formatC(25.0, digits = 1, format = "f"), "%"),
      "Some Other Info",
      icon = icon("list"),
      color = "yellow"
    )
  })
  
  ###SMOKER - Modified Risk
  if(input$Smoker == "Yes")
    tmpRisk <- exp(anyCompl-0.1309884)*100 else tmpRisk <- exp(anyCompl)*100
  output$generic2 <- renderValueBox({
    valueBox(
      paste0(formatC(tmpRisk, digits = 1, format = "f"), "%"),
      "If you stopped smoking",
      icon = icon("list"),
      color = "yellow"
    )
  })
  
  ###BMI - 10% weight reduction
  output$generic3 <- renderValueBox({

    anyCompl <- anyCompl - (BMIFactor*BMI)
    weight <- as.numeric(input$weight)
    height <- as.numeric(input$height)
    BMI <- ((weight-0.1*weight)/height/height) * 10000
    anyCompl <- anyCompl + (0.0094137*BMI)
    tmpRisk <- exp(anyCompl)*100
    lbsLose <- formatC(0.1*weight/2.20462, digits = 1, format = "f")

    valueBox(
      paste0(formatC(tmpRisk, digits = 1, format = "f"), "%"),
      paste0("If you lost ", lbsLose, " lbs"),
      icon = icon("scale", lib = "glyphicon"),
      color = "blue"
    )
  })
  

  output$generic4 <- renderValueBox({
    valueBox(
      paste0(formatC(25.0, digits = 1, format = "f"), "%"),
      "Some Other Info",
      icon = icon("list"),
      color = "green"
    )
  })
  
  #Create the risk plot graph
  output$riskPlot2 <- renderPlot ({

    
    df3 <- data.frame(units = c(4.7, 6.7, 20),
                      what = c('If you lost X lbs', 'If you stopped smoking',
                               'Your Current Risk')
                      )
    
    posx <- runif(1000, 0, 10)
    posy <- data.frame(1, 2, 3)#runif(1000, 0, 5)
    ggplot(data.frame(x = c(85, 70, 20), y =c(1, 2, 3)), aes(x, y)) + geom_emoji(emoji="1f63b")
    
    
    # ggplot(df3, aes(units, what)) + 
    #   geom_bar(fill="white",
    #            colour="darkgreen",
    #            alpha=0.5,
    #            stat="identity") +
    #   coord_flip() + 
    #   scale_x_discrete() + geom_emoji(emoji="1f697") + 
    #  theme_bw() +
    #   theme(axis.title.x  = element_blank(), axis.title.y  = element_blank())
    
    # scale_y_continuous(breaks=seq(1, 20, 40)) + 
  })
  
  
  
  }) # end submit button method

})

calcBMI <- function(weight=0, height=0){
  return((weight/height/height) * 10000)
}



  # #Exponate the value and multiple by 100 to get a %
  # # anyCompl <- exp(anyCompl)*100
  # 
  # # #Print the final result ot the console
  # # print("Calculated anyCompl:")
  # # print(anyCompl)
  # 
  # 

  # 
  # #generic fields
  # 

  # (anyCompl)*100

  # 
  # 
  # #Row 2 generic 1st

  # #Row 2 generic 2nd
  # output$generic4 <- renderValueBox({
  #   valueBox(
  #     paste0(formatC(25.0, digits = 1, format = "f"), "%"),
  #     "Some Other Info",
  #     icon = icon("list"),
  #     color = "red"
  #   )
  # })
  # 
  # #Row 2 generic 3rd

#}




# output$distPlot <- renderPlot({
# 
#   # generate bins based on input$PtAge from ui.R
#   x    <- faithful[, 2]
#   bins <- seq(min(x), max(x), length.out = input$PtAge + 1)
#   
#   # draw the histogram with the specified number of bins
#   hist(x, breaks = bins, col = 'darkgray', border = 'white')
#   
#   calcBMI()
# })
# 


# # img <- readPNG(system.file("img", "cigarette.ong", package="png"))
#  pictogram(icon = system.file("img", "cigarette.ong", package="png"), n = c( 12, 35, 7),
#            grouplabels=c("12 R logos","35 R logos","7 R logos"))

# man<-readPNG("cigarette.png")
# pictogram(icon=man,
#           n=c(100,35,25),
#           grouplabels=c("dudes","chaps","lads"), hicons=100, vspace=1 )





# 
# # make gs an ordered factor
# df3$what <- factor(df3$what, levels = df3$what, ordered = TRUE)
# 
# #plots
# ggplot(df3, aes(what, units)) + geom_bar(fill="white", colour="darkgreen",
#                                          alpha=0.5, stat="identity") + coord_flip() + scale_x_discrete() +
#   scale_y_continuous(breaks=seq(0, 20, 2)) + theme_bw() +
#   theme(axis.title.x  = element_blank(), axis.title.y  = element_blank())



# observeEvent(input$weight, {
#   if(input$weight!='')
#     if(input$weight!='')
#     updateTextInput(session, "BMI", value="success")
# })
# 
# observeEvent(input$weight, {
#   if(input$weight!='')
#     if(input$weight!='')
#     updateTextInput(session, "BMI", value="success")
# })

