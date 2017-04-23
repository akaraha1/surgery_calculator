
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

BMI <<- 0.00
anyCompl <<- 0.00

shinyServer(function(input, output, session) {

  
  

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
  
  observeEvent(input$Submit, {
      updateTabsetPanel(session, "tab", 'dataViewer')
  })
  
  
  output$riskPlot <- renderPlot ({
    barplot(VADeaths, angle = 15+10*1:5, density = 20, col = "black",
            legend = rownames(VADeaths))
    title(main = list("Some Data...", font = 4))
    calcBMI()
    calcAnyComp()
  })
  
  # output$BMI <- renderText({
  #   print("in here")
  #   input$weight
  #   })
  
  observeEvent(input$weight, {
    if(input$weight!='')
      if(input$weight!='')
      updateTextInput(session, "BMI", value="success")
  })
  
  observeEvent(input$weight, {
    if(input$weight!='')
      if(input$weight!='')
      updateTextInput(session, "BMI", value="success")
  })
  
  
  

  
  calcBMI <- reactive({
   
    
    
  })
  
  
  calcAnyComp <- reactive({
    anyCompl <- 0 #ensure we're starting with a 0'd variable
   # calcBMI()     #make sure we have an updated BMI value

    #gender
    gender <- switch(input$GenderButton, "Male" = 1, "Female" = 0)
    anyCompl <- anyCompl + (-0.0242882*gender)
    
    #race
    race <- switch(input$RaceButton, "White" = 1, "Non-White" = 0)
    anyCompl <- anyCompl + (0.0596692*race)
    
    #age 
    anyCompl <- anyCompl + (0.0028318*input$PtAge)
    
    #0 is no, 1 is yes
    #Surgery Type
    anyCompl <- anyCompl + (switch(input$SurgeryType,
                                   "Pancreas" = 0,
                                   "Stomach" = -0.5105275,
                                   "Colon" = -0.8071903, 0))
  
    #CancerGI 
    anyCompl <- anyCompl + (0.0870107*switch(input$GICancer,
                                           "Cancer Surgery" = 1,
                                           "Benign disease" = 0, 0))

    #Functional Status
    anyCompl <- anyCompl + (-0.5353748*switch(input$FunctionalStatus,
                                        "Totally Depdendent" = 0,
                                        "Partially Dependent" = 1,
                                        "Fully Independent" = 2, 2))
    
    
    #asaclass
    anyCompl <- anyCompl + (0.4420653*switch(input$OtherMedical, "Totally Healthy" = 1,
                                             "Mild diseases" = 2,
                                             "Severe diseases" = 3,
                                             "Near death" = 4, 1))
    
    #steroid
    anyCompl <- anyCompl + (0.4215457*switch(input$steroids, "Yes" = 1, "No" = 0, 0))
    
    #ascites
    anyCompl <- anyCompl + (0.7761558*switch(input$ascites, "Yes" = 1, "No" = 0, 0))
    
    #  Septic
    anyCompl <- anyCompl + (0.7766535*switch(input$septic, "Yes" = 1, "No" = 0, 0))
    
    #ventilat
    anyCompl <- anyCompl + (0.904599*switch(input$vent, "Yes" = 1, "No" = 0, 0))
    
    #DMall
    anyCompl <- anyCompl + (0.0697649*switch(input$DMall, "Yes" = 1, "No" = 0, 0))
    
    #hypermed
    anyCompl <- anyCompl + (0.0406726*switch(input$HTNMeds, "Yes" = 1, "No" = 0, 0))
    
    #hxchf
    anyCompl <- anyCompl + (0.2994934*switch(input$HxCHF, "Yes" = 1, "No" = 0, 0))
    
    #SOB
    anyCompl <- anyCompl + (0.2186209*switch(input$SOB, "Yes" = 1, "No" = 0, 0))
    
    #smoker
    anyCompl <- anyCompl + (0.1309884*switch(input$Smoker, "Yes" = 1, "No" = 0, 0))
                                    
    #hxcopd
    anyCompl <- anyCompl + (0.2158972*switch(input$HxCOPD, "Yes" = 1, "No" = 0, 0))
    
    #dialysis
    anyCompl <- anyCompl + (0.1193262*switch(input$Dialysis, "Yes" = 1, "No" = 0, 0))
                                      
     # renafail
    anyCompl <- anyCompl + (0.3735297*switch(input$RenalFailure, "Yes" = 1, "No" = 0, 0))
    


    #bmi
   # calcBMI()
    if(is.numeric(input$BMI) == FALSE) {
      weight <- as.numeric(input$weight)
      height <- as.numeric(input$height)
      BMI <- (weight/height/height) * 10000
    }
    else {
      BMI <- input$BMI
    }
    updateTextInput(session, 'BMI', value = formatC(BMI, digits = 2, format = "f"))
    output$rate <- renderValueBox({
      valueBox(formatC(BMI, digits = 1, format = "f"), subtitle = "BMI",
               icon = icon("area-chart"),
               color = if (BMI > 25) "red" else "aqua"
      )
    })
    print("BMI:")
    print(BMI)
    anyCompl <- anyCompl + (0.0094137*BMI)
    
    #_cons
    anyCompl <- anyCompl-1.761664 

    #Exponate the value and multiple by 100 to get a %
   # anyCompl <- exp(anyCompl)*100
  
    # #Print the final result ot the console
    # print("Calculated anyCompl:")
    # print(anyCompl)
    

    output$anyComplBox <- renderValueBox({
      valueBox(
        paste0(formatC(exp(anyCompl)*100, digits = 1, format = "f"), "%"),
        "Major Complication Risk",
        icon = icon("list"),
        color = "purple"
        )
    })
    
    #generic fields
    
    #Row 1 generic 3rd
    output$generic1 <- renderValueBox({
      valueBox(
        paste0(formatC(25.0, digits = 1, format = "f"), "%"),
        "Some Other Info",
        icon = icon("list"),
        color = "yellow"
      )
    })
    (anyCompl)*100
    #Row 2 generic 1st
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

    
    #Row 2 generic 1st
    output$generic3 <- renderValueBox({
      valueBox(
        paste0(formatC(25.0, digits = 1, format = "f"), "%"),
        "Some Other Info",
        icon = icon("list"),
        color = "blue"
      )
    })
    #Row 2 generic 2nd
    output$generic4 <- renderValueBox({
      valueBox(
        paste0(formatC(25.0, digits = 1, format = "f"), "%"),
        "Some Other Info",
        icon = icon("list"),
        color = "red"
      )
    })
    
    #Row 2 generic 3rd
    output$generic5 <- renderValueBox({
      valueBox(
        paste0(formatC(25.0, digits = 1, format = "f"), "%"),
        "Some Other Info",
        icon = icon("list"),
        color = "green"
      )
    })
    
    
    
    

  })
  
  
})






