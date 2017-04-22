
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
    
    # There are three categories of surgery (instead of the near infinite number of procedure codes in the real NSQIP: pancreas (ref category), stomach(GastRxn), and colon
    #CancerGI is a binary variable we introduced, 1 = surgery for cancer, 0 = surgery for benign disease
    #Functional is functional status, 0 = total dependent, 1 = partially dependent, 2 = fully independent
    #CancerGI is a binary variable we introduced, 1 = surgery for cancer, 0 = surgery for benign disease
    #Functional is functional status, 0 = total dependent, 1 = partially dependent, 2 = fully independent
    #asaclass is a measure of other medical problems 1 = totally healthy, 2 = mild diseases, 3 = severe diseases, 4 = near death
    # 
    
    
    #0 is no, 1 is yes
      #GastRxn -.5105275
      #colonRxn -.8071903
      #CancerGI .0870107
   # radioButtons("SurgeryType","Surgery:", inline = FALSE, choices = c("Pancreas", "stomach", "colon"),
    
  #  radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE, choices = c("Yes", "No"),

    
    #Functional |  -.5353748 -- radioButtons("FunctionalStatus","Functional Status:", inline = FALSE, choices = c("Totally Depdendent", "Partially Dependent", "Fully Independent"),

    #asaclass
    #totally healthy=1
    #mild diseases=2
    #severe diseases=3
    #near death=4
    asaClass <- switch(input$OtherMedical, "Totally Healthy" = 1,
                       "Mild diseases" = 2,
                       "Severe diseases" = 3,
                       "Near death" = 4)
    anyCompl <- anyCompl + (0.4420653*asaClass)
    
    
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
      BMI <- weight/(height^2)
    }
    else {
      BMI <- input$BMI
    }
    updateTextInput(session, 'BMI', value = formatC(BMI, digits = 2, format = "f"))
    output$rate <- renderValueBox({
      valueBox(formatC(BMI, digits = 1, format = "f"), subtitle = "BMI",
               icon = icon("area-chart"),
               color ="yellow"
      )
    })
    print("BMI:")
    print(BMI)
    anyCompl <- anyCompl + (0.0094137*BMI)
    
    #_cons
    anyCompl <- anyCompl-1.761664 

    #Exponate the value and multiple by 100 to get a %
    anyCompl <- exp(anyCompl)*100
  
    #Print the final result ot the console
    print("Calculated anyCompl:")
    print(anyCompl)
    
    output$anyComplBox <- renderInfoBox({
      infoBox(
        "Risk of Complications", formatC(anyCompl, digits = 1, format = "f"), icon = icon("list"),
        color = "purple"
      )
    })

  })
  
  
})






