# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(emoGG)
library(emojifont)
library(png)
library(googleVis)

library(grid)
library(gridSVG)
library("googlesheets")
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(googleVis))

library(DT)


BMI <- 0.00
anyComplRaw <- 0.00

df3 <- data.frame()
#gap_ss <- gs_gap()





shinyServer(function(input, output, session) {


  observeEvent(input$Submit, {
    
    #Switches from the quertionaire view to the data view
    # when the submit button is pressed
    updateTabsetPanel(session, "tab", 'dataViewer')
    
    
        
    #Set the BMI variable
    BMI <- input$BMI
    
    #Create variables for the modifiable risk factors
    functStatus <- switch(input$FunctionalStatus,
                          "Totally Depdendent" = 0,
                          "Partially Dependent" = 1,
                          "Fully Independent" = 2, 2)
    steroidStatus <- switch(input$steroids,
                            "Yes" = 1,
                            "No" = 0, 0)
    CHFStatus <- switch(input$HxCHF, "Yes" = 1, "No" = 0, 0)
    SOBStatus <- switch(input$SOB, "Yes" = 1, "No" = 0, 0)
    COPDStatus <- switch(input$HxCOPD, "Yes" = 1, "No" = 0, 0)
    SmokerStatus <- switch(input$Smoker, "Yes" = 1, "No" = 0, 0)
    HTNStatus <- switch(input$HTNMeds, "Yes" = 1, "No" = 0, 0)
    DMStatus <- switch(input$DMall, "Yes" = 1, "No" = 0, 0)
    
    
  ###Calculate the Major Complication Risk
  anyComplRaw <- 0.00  #Make sure we're starting from 0
  anyComplRaw <- sexFactor*switch(input$GenderButton, "Male" = 1, "Female" = 0)
  anyComplRaw <- anyComplRaw + raceFactor*switch(input$RaceButton, "White" = 1, "Non-White" = 0, 1)
  anyComplRaw <- anyComplRaw + ageFactor*input$PtAge
  anyComplRaw <- anyComplRaw + switch(input$SurgeryTypeButton,
                                "Pancreas" = 0,
                                "Stomach" = GastRxnFactor,
                                "Colon" = ColonRxnFactor)
  anyComplRaw <- anyComplRaw + switch(input$SurgeryTypeButton,
                                "Pancreas" = 0,
                                "Stomach" = -0.5105275,
                                "Colon" = -0.8071903, 0)
  anyComplRaw <- anyComplRaw + FunctionalFactor*functStatus
  anyComplRaw <- anyComplRaw + CancerGIFactor*switch(input$GICancer,
                                               "Cancer Surgery" = 1,
                                               "Benign disease" = 0, 0)
  anyComplRaw <- anyComplRaw + asaclassFactor*switch(input$OtherMedical, "1: Totally Healthy" = 1,
                                               "2: Mild diseases" = 2,
                                               "3: Severe diseases" = 3,
                                               "4: Near death" = 4, 1)
  anyComplRaw <- anyComplRaw + steroidFactor*steroidStatus
  anyComplRaw <- anyComplRaw + ascitesFactor*switch(input$ascites, "Yes" = 1, "No" = 0, 0)
  anyComplRaw <- anyComplRaw + SepticFactor*switch(input$septic, "Yes" = 1, "No" = 0, 0)
  anyComplRaw <- anyComplRaw + ventilarFactor*switch(input$vent, "Yes" = 1, "No" = 0, 0)
  anyComplRaw <- anyComplRaw + DMallFactor*DMStatus
  anyComplRaw <- anyComplRaw + hypermedFactor*HTNStatus
  anyComplRaw <- anyComplRaw + hxchfFactor*CHFStatus
  anyComplRaw <- anyComplRaw + SOBFactor*SOBStatus
  anyComplRaw <- anyComplRaw + smokerFactor*SmokerStatus
  anyComplRaw <- anyComplRaw + hxcopdFactor*COPDStatus
  anyComplRaw <- anyComplRaw + dialysisFactor*switch(input$Dialysis, "Yes" = 1, "No" = 0, 0)
  anyComplRaw <- anyComplRaw + renafailFactor*switch(input$RenalFailure, "Yes" = 1, "No" = 0, 0)
  anyComplRaw <- anyComplRaw + BMIFactor*BMI
  anyComplRaw <- anyComplRaw + consFactor
  
  ###MAJOR RISK COMPLICATION BOX
  output$majorComplicationBox <- renderValueBox({
    valueBox(
      paste0(formatC(calcRiskFinal(anyComplRaw), digits = 1, format = "f"), "%"),
      "Major Complication Risk",
      icon = icon("plus-square"),
      color = "purple"
    )
  })
  
  ###Modifiable Risk Factors - in order by contribution
  source(file.path("ModifiableRiskInfoBoxesServer.R"),  local = TRUE)$value
  
  output$hp<-renderGvis({
    
    gvisGauge(data.frame(Item='BMI',Value=BMI),
              options=list(min=0,
                           max=55,
                           greenFrom=15,
                           greenTo=25,
                           yellowFrom=25,
                           yellowTo=35,
                           redFrom=35, redTo=55)
    )
  })    
  
  #Create the risk plot graph
  output$riskPlot <- renderPlot ({
    
    df3 <- data.frame(units = c(8, 7, 2), 
                      what = c('Risk Profile 1',
                               'Risk Profile 2', 'Risk Profile 3'
                      ))
    df3$what <- factor(df3$what, levels = df3$what, ordered = TRUE)
    
    library(png)
    fill_images <- function()
    {
      l <- list()
      for (i in 1:nrow(df3)) 
      {
        for (j in 1:floor(df3$units[i]))
        {
          #seems redundant, but does not work if moved outside of the loop (why?)
          img <- readPNG("cigarette.png")
          g <- rasterGrob(img, interpolate=TRUE)
          l <- c(l, annotation_custom(g, xmin = i-1/2, xmax = i+1/2, ymin = j-1, ymax = j))
        }
      }
      l
    }
    
    ggplot(df3, aes(what, units)) + 
      geom_bar(fill="white", colour="darkgreen", alpha=0.5, stat="identity") + 
      coord_flip() + 
      scale_y_continuous(breaks=seq(100,5)) + 
      scale_x_discrete(breaks=seq(100,0)) + 
      theme_bw() + 
      theme(axis.title.x  = element_blank(), axis.title.y  = element_blank()) + 
      fill_images()
    
  })
  
  
  
  
  
  
  
  
  
  
  
  


  # ###BMI valuebox - Setup
  # output$BMIBox <- renderValueBox({
  #   valueBox(formatC(BMI, digits = 1, format = "f"), subtitle = "BMI",
  #            icon = icon("area-chart"),
  #            color = if (BMI > 25) "red" else "aqua"
  #   )
  # })
  # #Update the text in the BMI text field
  # updateTextInput(session, 'BMI', value = formatC(BMI, digits = 2, format = "f"))
  

  
  # ###SOME OTHER INFO
  # output$generic1 <- renderValueBox({
  #   valueBox(
  #     paste0(formatC(25.0, digits = 1, format = "f"), "%"),
  #     "Some Other Info",
  #     icon = icon("list"),
  #     color = "yellow"
  #   )
  # })
  
  ###SMOKER - Modified Risk
  if(input$Smoker == "Yes")
    tmpRisk <- exp(anyCompl-smokerFactor)*100 else tmpRisk <- exp(anyCompl)*100
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

    anyComplRaw <- anyComplRaw - (BMIFactor*BMI)
    weight <- as.numeric(input$weight)
    height <- as.numeric(input$height)
    BMI <- ((weight-0.1*weight)/height/height) * 10000
    anyComplRaw <- anyComplRaw + (0.0094137*BMI)
    tmpRisk <- exp(anyComplRaw)*100
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
    
    
    
  })
  
  output$riskPlot3 <- renderPlot ({
    
    ## Dummy data graph
    barplot(VADeaths,
            angle = 15+10*1:5,
            density = 20,
            col = "black",
            border = "red",
            legend = rownames(VADeaths),
            xlab = "Risk Profile",
            ylab = "Expected Deaths",
            names.arg = c("Risk Profile 1",
                          "Risk Profile 2",
                          "Risk Profile 3",
                          "Risk Profile 4"))
    title(main = list("Some Demo Data...", font = 4))
    
  })
  
  
  
  }) # end submit button method

  ###To collapse the Menuside bar but keep the icons visible
  runjs({'
        var el2 = document.querySelector(".skin-blue");
    el2.className = "skin-blue sidebar-mini";
    var clicker = document.querySelector(".sidebar-toggle");
    clicker.id = "switchState";
    '})
  
  onclick('switchState', runjs({'
    var title = document.querySelector(".logo")
    if (title.style.visibility == "hidden") {
    title.style.visibility = "visible";
    } else {
    title.style.visibility = "hidden";
    }
    '}))
  
  #Submit to google sheet
  observeEvent(
    input$submitToGoogle,
   # gap <- gs_key("1Fhan4CT5wTdLDmNoD89JvHeeTfQmKtHbTfIyd7G3a1k"),
    gs_add_row(gs_key("1Fhan4CT5wTdLDmNoD89JvHeeTfQmKtHbTfIyd7G3a1k"),
               ws = "RiskOutputs",
               input = data.frame("new conet[i, ]", "cell2"))

   )

})

###Not in use at the moment
# calcBMI <- function(weight=0, height=0){
#   if ((weight/height/height) * 10000 > 55) {
#     return(55)
#   }
#   return((weight/height/height) * 10000)
# }

calcRiskFinal <- function(rawAnyCompl=0){
  if(exp(rawAnyCompl)*100 > 100)
    return(100)
  return(exp(rawAnyCompl)*100)
}





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




# # img <- readPNG(system.file("img", "cigarette.ong", package="png"))
#  pictogram(icon = system.file("img", "cigarette.ong", package="png"), n = c( 12, 35, 7),
#            grouplabels=c("12 R logos","35 R logos","7 R logos"))

# man<-readPNG("cigarette.png")
# pictogram(icon=man,
#           n=c(100,35,25),
#           grouplabels=c("dudes","chaps","lads"), hicons=100, vspace=1 )


fill_images <- function()
{
  l <- list()
  for (i in 1:nrow(df3)) 
  {
    for (j in 1:ceiling(7))
    {
      img <- readPNG("cigarette.png")
      #g <- rasterGrob(img, interpolate=TRUE)
      l <- c(l, annotation_custom(img, xmin = i-1/2, xmax = i+1/2, ymin = j-1, ymax = j))
    }
  }
  l
}

clip_images <- function(restore_grid = TRUE)
{
  l <- list()
  for (i in 1:nrow(df3)) 
  {
    l <- c(l, geom_rect(xmin = i-1/2, xmax = i+1/2, 
                        ymin = df3$units[i], ymax = ceiling(7),
                        colour = "white", fill = "white"))
    if (restore_grid && ceiling(7) %in% major_grid) 
      l <- c(l, geom_segment(x = i-1, xend = i+1,
                             y = ceiling(7), 
                             yend = ceiling(7),
                             colour = grid_col, size = grid_size))
  }
  l
}




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


# ggplot(df3, aes(units, what)) +
#   geom_bar(fill="white",
#            colour="darkgreen",
#            alpha=0.5,
#            stat="identity") +
#   coord_flip() +
#   scale_x_discrete() + geom_emoji(emoji="1f63b") +
#  theme_bw() +
#   theme(axis.title.x  = element_blank(), axis.title.y  = element_blank()) +
#   scale_y_continuous(name = waiver(), breaks = waiver(),
#                      minor_breaks = waiver(), labels = waiver(), limits = NULL,
#                      expand = waiver(), na.value = NA_real_,
#                      trans = "identity", position = "left", sec.axis = waiver()) +
#   scale_y_continuous(limits=c(0, 1200), breaks=c(0, 400, 800, 1200))
#scale_y_continuous()



# x = seq(0, 2*pi, length=30)
# y = sin(x)
# ggplot() + geom_emoji('heartbeat', x=x, y=y, size=10)
# 

# if(is.numeric(input$BMI))
#   BMI <- as.numeric(input$BMI)
# else
#   BMI <- calcBMI(weight=as.numeric(input$weight), height=as.numeric(input$height))

