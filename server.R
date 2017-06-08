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

library(dplyr)

library(grid)
library(gridSVG)
library(plotly)


suppressPackageStartupMessages(library(googleVis))
source(file.path("MajorComplCalculation.R"),  local = TRUE)$value

dfMaster <- data.frame()      #the master df holding input variables and final outputs
dfRiskChanges <<- data.frame() #the risk changes


shinyServer(function(input, output, session) {

  observeEvent(input$Submit, {
    
    #Switches from the quertionaire view to the data view
    # when the submit button is pressed
    updateTabsetPanel(session, "tab", 'dataViewer')

    dfMaster <<- data.frame(
      -1, #placeholder for timestamp
      -1, #placeholder for MRN
      switch(input$GenderButton, "Male" = 1, "Female" = 0),
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
      if(input$steroids == TRUE) 1 else 0,
      if(input$ascites == TRUE) 1 else 0,
      if(input$septic == TRUE) 1 else 0,
      if(input$vent == TRUE) 1 else 0,
      if(input$DMall == TRUE) 1 else 0,
      if(input$HTNMeds == TRUE) 1 else 0,
      if(input$HxCHF == TRUE) 1 else 0,
      if(input$SOB == TRUE) 1 else 0,
      if(input$Smoker == TRUE) 1 else 0,
      if(input$HxCOPD == TRUE) 1 else 0,
      if(input$Dialysis == TRUE) 1 else 0,
      if(input$RenalFailure == TRUE) 1 else 0,
      input$BMI,
      -1, #placeholder for major complications - raw
      -1,  #placeholder for major complication
      -1, #placeholder for death risk - raw
      -1 #placeholder for death risk - calculated
      )
    
    colnames(dfMaster) <<- c('Timestamp', 'MRN', 'Sex', 'Race', 'Age',
                             'Surgery', 'Cancer', 'Funcational',
                             'ASAClass', 'Steroid', 'Ascites', 'Septic',
                             'Vent', 'DMAll', 'HTNMed', 'HxCHF', 'SOB',
                             'Smoker', 'HxCOPD', 'Dialysis', 'RenalFailure',
                             'BMI', 'Raw_MajorComplications',
                             'MajorComplications', 'Raw_DeathRisk', 'DeathRisk'
                             )
    
  #Calculate the surgery risk for major complications via
  # the method in 'MajorComplCalculation.R'
  dfMaster[1,'Raw_MajorComplications'] <<- CalcMajorRisk()
  dfMaster[1,'MajorComplications']     <<- expMajorRisk(dfMaster[1,'Raw_MajorComplications'])
  
  #Calculate the death risk via
  # the method in 'MajorComplCalculation.R'
  dfMaster[1,'Raw_DeathRisk'] <<- CalcDeathRisk()
  dfMaster[1,'DeathRisk']     <<- expMajorRisk(dfMaster[1,'Raw_DeathRisk'])
  
  ###MAJOR RISK COMPLICATION BOX
  output$majorComplicationBox <- renderValueBox({
    valueBox(
      paste0(formatC(dfMaster[1,'MajorComplications'], digits = 1, format = "f"), "%"),
      "Major Complication Risk", icon = icon("plus-square"), color = "purple"
    )
  })
  
  ###DEATH RISK COMPLICATION BOX
  output$deathRiskBox <- renderValueBox({
    valueBox(
      paste0(formatC(dfMaster[1,'DeathRisk'], digits = 1, format = "f"), "%"),
      "Risk of Death", icon = icon("plus-square"), color = "purple"
    )
  })
  
  #Setup a risk change dataFrame with null values (-1) and
  #assign names to the columns
  dfRiskChanges <<- data.frame(-1, -1, -1, -1, -1, -1, -1, -1)
  colnames(dfRiskChanges) <<- c('Funcational', 'Steroid', 'HxCHF', 'SOB',
                                'HxCOPD', 'Smoker', 'DMAll', 'HTNMed')
  
  #Function change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'Funcational'] < 2) {
    tmpRisk <- dfMaster[1,'Raw_MajorComplications'] - majorComp_FunctionalFactor*dfMaster[1, 'Funcational'] + majorComp_FunctionalFactor*2
    newRisk <- expMajorRisk(tmpRisk) - expMajorRisk(dfMaster[1,'Raw_MajorComplications']) 
    dfRiskChanges[,'Funcational'] <<- newRisk
  }
  
  #Steroid change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'Steroid']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_steroidFactor)
    dfRiskChanges[,'Steroid'] <<- riskChange
  }
  
  #CHF change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'HxCHF']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hxchfFactor)
    dfRiskChanges[,'HxCHF'] <<- riskChange
  }

  #SOB change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'SOB']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_SOBFactor)
    dfRiskChanges[,'SOB'] <<- riskChange
  }

  #COPD change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'HxCOPD']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hxcopdFactor)
    dfRiskChanges[,'HxCOPD'] <<- riskChange
  }

  #Smoker change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'Smoker']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_smokerFactor)
    dfRiskChanges[,'Smoker'] <<- riskChange
  }

  #DMAll change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'DMAll']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_DMallFactor)
    dfRiskChanges[,'DMAll'] <<- riskChange
  }

  #HTN Med change in risk
  #Calculate the new risk and place it in dfRiskChanges dataFrame
  if(dfMaster[1, 'HTNMed']) {
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hypermedFactor)
    dfRiskChanges[,'HTNMed'] <<- riskChange
  }
  
  #Add the infoBoxes to the Modifiable Risk Factors section
  #in order of their contribution
  source(file.path("UIFiles", "ModifiableRiskInfoBoxesServer.R"),  local = TRUE)$value
  
  #Setup Graph 1 when the load graph button is pressed
  observeEvent(input$LoadGraph1, {
    output$riskPlot <- renderPlot ({
      #Remove all the null (-1) values from the dataframe
      dfRiskChanges <- dfRiskChanges[!grepl(-1,dfRiskChanges)]
      
      if(ncol(dfRiskChanges) == 0) {
        #If this graph is not meaninful (ie. there are no modifiable risk
        #factors selected) - animate hiding the box and show a notification
        hide(id = "graph1Box-outer", anim = TRUE)
        showNotification("Graph 1 is not meaningful for this patient.",
                         duration = 8,
                         type = "message")
        return()
      }
      #Setup a new dataFrame aligned to work with the RiskGraphPictogram file
      newDF <- data.frame(
        units = c(),
        what = c())
      
      #Add the person's baseline risk
      newDF <- rbind(newDF, data.frame(
          units = c(dfMaster[1,'MajorComplications']),
          what = c('Current Risk')
        ))
      
      
      #Loop through the risk changes and add them to the new (tmp)
      #dataFrame to then be plotted
      for(i in 1:ncol(dfRiskChanges)) {
        if(nrow(newDF) >= 2) {
          print("subtracting...")
          print(newDF$units[nrow(newDF-1)])
          print("from")
          print(dfRiskChanges[1,i])
          newRiskAdd <- newDF$units[nrow(newDF-1)]-dfRiskChanges[1,i]
        }
        else
          newRiskAdd <- dfMaster[1,'MajorComplications']-dfRiskChanges[1,i]
        
        newDF <- rbind(newDF, data.frame(
          units = c(newRiskAdd),
          what = c(colnames(dfRiskChanges)[i])
        ))
      }

      print(newDF)
     # newDF <- reorder(newDF$units, X= newDF$units, FUN = length)      
#      newDF <- reorder(newDF$units, X= newDF$units, FUN = length)      

      
      #$newDF <- arrange(newDF,units)
      print(newDF)
      
      #Finally plot the 
      source(file.path("UIFiles", "RiskGraphPictogram.R"), local = TRUE)$value

      #Todo need to add a validity check for if there is no data in the df
      #and thus the graph isn't meaningful

    })
   
})

  #Create the risk plot graph
  # output$riskPlot <- renderPlot ({
  #   
  # })
  
  #Create the risk plot graph
  output$riskPlot2 <- renderPlot ({

    
    
    df3 <- data.frame(units = c(4.7, 6.7, 20),
                      what = c('If you lost X lbs', 'If you stopped smoking',
                               'Your Current Risk'))
    
    posx <- runif(1000, 0, 10)
    posy <- data.frame(1, 2, 3)#runif(1000, 0, 5)
    ggplot(data.frame(x = c(85, 70, 20), y =c(1, 2, 3)), aes(x, y)) + geom_emoji(emoji="1f63b")
    
  })
  
  output$riskPlot3 <- renderPlotly ({
    
    # p <- plot_ly (x = c( 0, 0 ),
    #          y = c( 0, 0),
    #          type = 'scatter',
    #          mode = 'markers',
    #          size = c( 5, 100 ),
    #          marker = list(color = c('red', 'blue'))) %>%
    #          layout(title = 'Styled Scatter',
    #                 yaxis = list(zeroline = FALSE),
    #                 xaxis = list(zeroline = FALSE))
    # p

    USPersonalExpenditure <- data.frame("Categorie" = rownames(USPersonalExpenditure), USPersonalExpenditure)
    data <- USPersonalExpenditure[, c('Categorie', 'X1960')]
    
    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
    
    p <- plot_ly(data, labels = ~Categorie, values = ~X1960, type = 'pie',
                 textposition = 'inside',
                 textinfo = 'label+percent',
                 insidetextfont = list(color = '#FFFFFF'),
                 hoverinfo = 'text',
                 text = ~paste('$', X1960, ' billions'),
                 marker = list(colors = colors,
                               line = list(color = '#FFFFFF', width = 1)),
                 #The 'pull' attribute can also be used to create space between the sectors
                 showlegend = FALSE) %>%
      layout(title = 'United States Personal Expenditures by Categories in 1960',
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    # p <- plot_ly() %>%
    #   add_pie(data = count(diamonds, cut), labels = ~cut, values = ~n,
    #           name = "Cut", domain = list(x = c(0, 0.4), y = c(0.4, 1))) %>%
    #   add_pie(data = count(diamonds, color), labels = ~cut, values = ~n,
    #           name = "Color", domain = list(x = c(0.6, 1), y = c(0.4, 1))) %>%
    #   add_pie(data = count(diamonds, clarity), labels = ~cut, values = ~n,
    #           name = "Clarity", domain = list(x = c(0.25, 0.75), y = c(0, 0.6))) %>%
    #   layout(title = "Pie Charts with Subplots", showlegend = F,
    #          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    #          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    # 
    p
    
    
#     p <- plot_ly(data = iris, x = ~Sepal.Length, y = ~Petal.Length,
#                  marker = list(size = 10,
#                                color = 'rgba(255, 182, 193, .9)',
#                                line = list(color = 'rgba(152, 0, 0, .8)',
#                                            width = 2))) %>%
#       layout(title = 'Styled Scatter',
#              yaxis = list(zeroline = FALSE),
#              xaxis = list(zeroline = FALSE))
# 
#   
# 
# 
# p
  
    # data <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/school_earnings.csv")
    # # 
    #  data$State <- as.factor(c('Massachusetts', 'California', 'Massachusetts', 'Pennsylvania', 'New Jersey', 'Illinois', 'Washington DC',
    #                            'Massachusetts', 'Connecticut', 'New York', 'North Carolina', 'New Hampshire', 'New York', 'Indiana',
    #                            'New York', 'Michigan', 'Rhode Island', 'California', 'Georgia', 'California', 'California'))
    #  
    # p <- plot_ly(data, x = ~Women, y = ~Men, text = ~School, type = 'scatter', mode = 'markers', size = ~gap, color = ~State, colors = 'Paired',
    #              marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
    #   layout(title = 'Gender Gap in Earnings per University',
    #          xaxis = list(showgrid = FALSE),
    #          yaxis = list(showgrid = FALSE),
    #          showlegend = FALSE)
    # 
    # 
    # p
    # 
    
    
  })

  
  }) # end submit button method

  dataModal <- function(failed = FALSE) {
    modalDialog(
      textInput("PtMRNInput", "Patient's MRN:",
                placeholder = '2 Letters Followed By 8 Digits (eg. AA12345678)'
      ),
      if (failed)
        div(tags$b("Invalid MRN format.", style = "color: red;")),
      
      footer = tagList(
        modalButton("Cancel"),
        actionButton("modalSubmit", "Submit to Server")
      )
    )
  }
  
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
  observeEvent(input$SavetoServer, {
    if(nrow(dfMaster) == 0) {
      #If there's no data don't allow a null submission
      showModal(modalDialog(
        title = "You must submit the questionaire before saving to the server",
        easyClose = TRUE,
        footer = NULL
      ))
    }
    else
      showModal(dataModal())
    }
  )               
               
  observeEvent(input$modalSubmit, {
      if(nchar(input$PtMRNInput) < 10 || nchar(input$PtMRNInput) > 10)
        showModal(dataModal(failed = TRUE))
      else {
        removeModal()
        BoxServerFx(input$PtMRNInput)
      }
    })
})



expMajorRisk <- function(rawAnyCompl=0){
  if(exp(rawAnyCompl)*100 > 100)
    return(100)
  return(exp(rawAnyCompl)*100)
}


BoxServerFx <- function(MRNInput = '') {
  
  dfMaster[1,'MRN'] <<- MRNInput
  dfMaster[1,'Timestamp'] <<- format(Sys.time())
  
  withProgress(message = 'Saving to Box...', value = 0, {
    
    incProgress(0/4, detail = paste("Logging into Box"))
    ##Submit the data
    box_auth(client_id = "4vmnrbf2c9n6rcbkk4n3cx1zfv76q5ud", client_secret = "LEVe7CaB9DUhKYF3v6W3lP7cbzAZuY9z")  # Authorize your account

    incProgress(1/4, detail = paste("Loading the files"))
    
    #Load the file
    df<- box_search("RiskSurgeryDataUpdated.xlsx") %>%    # Find a remote file
          box_read()

    incProgress(2/4, detail = paste("Adding new data to the file"))
  
    #Add the current data to the end of the old data
    dfMaster <- unname(dfMaster)
    df[nrow(df) + 1, ] <- dfMaster

    incProgress(3/4, detail = paste("Writing the file to Box"))
    
  
    #Write the data back to box
     box_write(df, filename = "RiskSurgeryDataUpdated.xlsx",
               dir_id = "26488602950", #the folder ID
               description = NULL)
  })
  showNotification(paste("Box upload finished"), duration = 5)
    
}



# ## Dummy data graph
# barplot(VADeaths,
#         angle = 15+10*1:5,
#         density = 20,
#         col = "black",
#         border = "red",
#         legend = rownames(VADeaths),
#         xlab = "Risk Profile",
#         ylab = "Expected Deaths",
#         names.arg = c("Risk Profile 1",
#                       "Risk Profile 2",
#                       "Risk Profile 3",
#                       "Risk Profile 4"))
# title(main = list("Some Demo Data...", font = 4))
# print("in here")
