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
#suppressPackageStartupMessages(library(dplyr))

source(file.path("MajorComplCalculation.R"),  local = TRUE)$value

dfMaster <- data.frame()

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
                           # switch(input$DMall, TRUE = 1, FALSE = 0, 0),
                           if(input$DMall == TRUE) 1 else 0,
                            #switch(input$HTNMeds, "Yes" = 1, "No" = 0, 0),
                           if(input$HTNMeds == TRUE) 1 else 0,
                            #switch(input$HxCHF, "Yes" = 1, "No" = 0, 0),
                           if(input$HxCHF == TRUE) 1 else 0,
                            switch(input$SOB, "Yes" = 1, "No" = 0, 0),
                            #switch(input$Smoker, "Yes" = 1, "No" = 0, 0),
                           if(input$Smoker == TRUE) 1 else 0,
                           # switch(input$HxCOPD, "Yes" = 1, "No" = 0, 0),
                           if(input$HxCOPD == TRUE) 1 else 0,
                            switch(input$Dialysis, "Yes" = 1, "No" = 0, 0),
                            switch(input$RenalFailure, "Yes" = 1, "No" = 0, 0),
                            input$BMI,
                            -1, #placeholder for major complications - raw
                            -1,  #placeholder for major complication
                            -1, #placeholder for death risk - raw
                            -1 #placeholder for death risk - calculated
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
                             'MajorComplications',
                             'Raw_DeathRisk',
                             'DeathRisk'
                             )
    

  #Calculate the surgery risk for major complications via
  # the method in 'MajorComplCalculation.R'
  dfMaster[1,'Raw_MajorComplications'] <<- CalcMajorRisk()
  dfMaster[1,'MajorComplications']     <<- expMajorRisk(dfMaster[1,'Raw_MajorComplications'])
  
  #Calculate the death risk via
  # the method in 'MajorComplCalculation.R'
  dfMaster[1,'Raw_DeathRisk'] <<- CalcDeathRisk()
  dfMaster[1,'DeathRisk']     <<- expMajorRisk(dfMaster[1,'Raw_DeathRisk'])
  print((dfMaster[1,'Raw_DeathRisk']))
  print(expMajorRisk(dfMaster[1,'Raw_DeathRisk']))
  
  
  
  ###MAJOR RISK COMPLICATION BOX
  output$majorComplicationBox <- renderValueBox({
    valueBox(
      paste0(formatC(dfMaster[1,'MajorComplications'], digits = 1, format = "f"), "%"),
      "Major Complication Risk",
      icon = icon("plus-square"),
      color = "purple"
    )
  })
  
  ###DEATH RISK COMPLICATION BOX
  output$deathRiskBox <- renderValueBox({
    valueBox(
      paste0(formatC(dfMaster[1,'DeathRisk'], digits = 1, format = "f"), "%"),
      "Risk of Death",
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
    df3 <- data.frame(units = c(14,
                                8,
                                8,
                                14,
                                19,
                                13.7,
                                20,
                                18,
                                4), 
                      what = c('Your Current Risk',
                               'Functional Status Contribution',
                               'Diabetes Contribtion', 
                               'Smoking Contribution',
                               'CHF Contribution',
                               'COPD Contribution', 
                               'Hypertension Contribution',
                               'Steroid Contribution',
                               'SOB Contribution'))
    
    # make gs an ordered factor
    df3$what <- factor(df3$what, levels = df3$what, ordered = TRUE)
    
    source(file.path("UIFiles", "RiskGraphPictogram.R"), local = TRUE)$value
    
  })
  
  #Create the risk plot graph
  output$riskPlot2 <- renderPlot ({

    df3 <- data.frame(units = c(4.7, 6.7, 20),
                      what = c('If you lost X lbs', 'If you stopped smoking',
                               'Your Current Risk'))
    
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


BoxServerFx <- function() {
  

  if(nrow(dfMaster) == 0) {
    #If there's no data don't allow a null submission
    showNotification("You cannot save data until you submit the questionaire.",
                     type = "error", duration = 5)
    return()
  }
  
  ##Submit the data
  box_auth(client_id = "4vmnrbf2c9n6rcbkk4n3cx1zfv76q5ud", client_secret = "LEVe7CaB9DUhKYF3v6W3lP7cbzAZuY9z")  # Authorize your account
  
  #Load the file
  df<- box_search("RiskSurgeryDataUpdated.xlsx") %>%    # Find a remote file
    box_read()
  
  #Add the current data to the end of the old data
  dfMaster <- unname(dfMaster)
  df[nrow(df) + 1, ] <- dfMaster
  
  #Write the data back to box
  box_write(df, filename = "RiskSurgeryDataUpdated.xlsx",
            dir_id = "26488602950", #the folder ID
            description = NULL)
}

