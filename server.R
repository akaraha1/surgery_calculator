# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(emoGG)
library(emojifont)

library(boxr)

library(googleVis)
suppressPackageStartupMessages(library(googleVis))

library(grid)
library(gridSVG)
suppressPackageStartupMessages(library(dplyr))

#library(DT)
#library(png)
source(file.path("MajorComplCalculation.R"),  local = TRUE)$value


#anyComplRaw <- 0.00

df3 <- data.frame()
dfMaster <- data.frame()
#gap_ss <- gs_gap()





shinyServer(function(input, output, session) {


  observeEvent(input$Submit, {
    
    #Switches from the quertionaire view to the data view
    # when the submit button is pressed
    updateTabsetPanel(session, "tab", 'dataViewer')

    dfMaster <<- data.frame(switch(input$GenderButton, "Male" = 1, "Female" = 0),
                            switch(input$RaceButton, "White" = 1, "Non-White" = 0, 1),
                            input$PtAge,
                            switch(input$SurgeryTypeButton,
                                   "Pancreas" = "Pancreas",
                                   "Stomach" = "Stomach",
                                   "Colon" = "Colon"),
                            switch(input$GICancer,
                                   "Cancer Surgery" = 1,
                                   "Benign disease" = 0, 0),
                            switch(input$FunctionalStatus,
                                   "Totally Depdendent" = 0,
                                   "Partially Dependent" = 1,
                                   "Fully Independent" = 2, 2),
                            switch(input$OtherMedical, "1: Totally Healthy" = 1,
                                   "2: Mild diseases" = 2,
                                   "3: Severe diseases" = 3,
                                   "4: Near death" = 4, 1),
                            switch(input$steroids, "Yes" = 1, "No" = 0, 0),
                            switch(input$ascites, "Yes" = 1, "No" = 0, 0),
                            switch(input$septic, "Yes" = 1, "No" = 0, 0),
                            switch(input$vent, "Yes" = 1, "No" = 0, 0),
                            switch(input$DMall, "Yes" = 1, "No" = 0, 0),
                            switch(input$HTNMeds, "Yes" = 1, "No" = 0, 0),
                            switch(input$HxCHF, "Yes" = 1, "No" = 0, 0),
                            switch(input$SOB, "Yes" = 1, "No" = 0, 0),
                            switch(input$Smoker, "Yes" = 1, "No" = 0, 0),
                            switch(input$HxCOPD, "Yes" = 1, "No" = 0, 0),
                            switch(input$Dialysis, "Yes" = 1, "No" = 0, 0),
                            switch(input$RenalFailure, "Yes" = 1, "No" = 0, 0),
                            input$BMI,
                            -1, #placeholder for raw major complications
                            -1  #placeholder for major complication
                            )
    
    colnames(dfMaster) <<- c('Sex',
                             'Race',
                             'Age',
                             'Surgery',
                             'Cancer',
                             'Funcational',
                             'ASAClass',
                             'Steroid',
                             'Ascites',
                             'Septic',
                             'Vent',
                             'DMAll',
                             'HTNMed',
                             'HxCHF',
                             'SOB',
                             'Smoker',
                             'HxCOPD',
                             'Dialysis',
                             'RenalFailure',
                             'BMI',
                             'Raw_MajorComplications',
                             'MajorComplications')
    

  #Calculate the surgery risk for major complications via
  # the method in 'MajorComplCalculation.R'
  dfMaster[1,'Raw_MajorComplications'] <<- CalcMajorRisk()
  dfMaster[1,'MajorComplications']     <<- expMajorRisk(dfMaster[1,'Raw_MajorComplications'])
  
  
  
  ###MAJOR RISK COMPLICATION BOX
  output$majorComplicationBox <- renderValueBox({
    valueBox(
      paste0(formatC(dfMaster[1,'MajorComplications'], digits = 1, format = "f"), "%"),
      "Major Complication Risk",
      icon = icon("plus-square"),
      color = "purple"
    )
  })
  
  ###Modifiable Risk Factors - in order by contribution
  source(file.path("UIFiles", "ModifiableRiskInfoBoxesServer.R"),  local = TRUE)$value
  
  output$hp<-renderGvis({
    
    gvisGauge(data.frame(Item='BMI',Value=dfMaster[1, 'BMI']),
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
  
  #Submit to Box
  observeEvent(
    input$SavetoServer,
    BoxServerFx()


   )
 

})

expMajorRisk <- function(rawAnyCompl=0){
  if(exp(rawAnyCompl)*100 > 100)
    return(100)
  return(exp(rawAnyCompl)*100)
}

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


BoxServerFx <- function() {
  
  if(nrow(dfMaster) == 0) {
    #If there's no data don't allow a null submission
    showNotification("You cannot save data until you submit the questionaire.",
                     type = "error", duration = 5)
    return()
  }
  
  ##Submit the data
  box_auth()  # Authorize your account
  
  #Load the file
  df<- box_search("RiskSurgeryData.xlsx") %>%    # Find a remote file
    box_read()
  
  #Add the current data to the end of the old data
  dfMaster <- unname(dfMaster)
  df[nrow(df) + 1, ] <- dfMaster
  
  #Write the data back to box
  box_write(df, filename = "RiskSurgeryDataUpdated.xlsx",
            dir_id = "26488602950", #the folder ID
            description = NULL)
}

