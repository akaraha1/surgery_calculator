
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {

  BMI <<- 0.00
  anyCompl <<- 0.00
  
  
  output$distPlot <- renderPlot({

    # generate bins based on input$PtAge from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$PtAge + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    calcBMI()
  })
  
  output$riskPlot <- renderPlot ({
    barplot(VADeaths, angle = 15+10*1:5, density = 20, col = "black",
            legend = rownames(VADeaths))
    title(main = list("Death Rates in Virginia", font = 4))
    calcBMI()
    
    
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
    #anyCompl <-
      
      #sex -.0242882
      #race .0596692
      #age .0028318
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
    #   bmi |   .0094137 
    #_cons |  -1.761664 
    
    
      
  })
  
  
})






