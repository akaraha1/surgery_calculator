
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
  
  
  
  output$BMIBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  
  calcBMI <- reactive({
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
    
  })
  
  
  calcAnyComp <- reactive({
    anyCompl <- 0 #ensure we're starting with a 0'd variable
    calcBMI()     #make sure we have an updated BMI value

    #gender
    gender <- switch(input$GenderButton, "Male" = 1, "Female" = 0)
    anyCompl <- anyCompl + (-0.0242882*gender)
    
    #race
    race <- switch(input$RaceButton, "White" = 1, "Non-White" = 0)
    anyCompl <- anyCompl + (0.0596692*race)
    
    #age 
    anyCompl <- anyCompl + (0.0028318*input$PtAge)
    
    # There are three categories of surgery (instead of the near infinite number of procedure codes in the real NSQIP: pancreas (ref category), stomach(GastRxn), and colon
    #                                        CancerGI is a binary variable we introduced, 1 = surgery for cancer, 0 = surgery for benign disease
    #                                        Functional is functional status, 0 = total dependent, 1 = partially dependent, 2 = fully independent
    #                                        asaclass is a measure of other medical problems 1 = totally healthy, 2 = mild diseases, 3 = severe diseases, 4 = near death
    # 
    
    
    #0 is no, 1 is yes
      #GastRxn -.5105275
      #colonRxn -.8071903
      #CancerGI .0870107
    #Functional |  -.5353748
    #asaclass |   .4420653
    #steroid |   .4215457
    #ascites |   .7761558
    #  Septic |   .7766535
    #ventilat |    .904599 
    #DMall |   .0697649
    #hypermed |   .0406726 
    #hxchf |   .2994934 
    #  SOB |   .2186209 
    #smoker |   .1309884 
    #hxcopd |   .2158972
    #dialysis |   .1193262 
    # renafail |   .3735297
    #bmi
    print(BMI)
    anyCompl <- anyCompl + (0.0094137*BMI)
    
    
    #_cons |  -1.761664 
    
    print(anyCompl)

    
      
  })
  
  
})






