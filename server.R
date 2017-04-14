
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {

  output$distPlot <- renderPlot({

    # generate bins based on input$PtAge from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$PtAge + 1)
    
    #put the tab 2 text box data on tab 2
    output$out2 <- renderText(input$box2)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
   # output$BMI <- renderText(input$weight)
    
    if(is.numeric(input$BMI) == FALSE) {
       weight <- as.numeric(input$weight)
       height <- as.numeric(input$height)
       BMI <- weight/(height^2)
      updateTextInput(session, 'BMI', value = round(BMI, 2))
    }

  })
  
  
  output$rate <- renderValueBox({

    
    valueBox(
      value = formatC(5.232523, digits = 1, format = "f"),
      subtitle = "Major Complication Risk",
      icon = icon("bar-chart"),
      color = "yellow",
      width = 10
    )
  })
  

  # function(session, input, output) {
  #   observeEvent(input$weight, {
  #     print("5")
  #     updateTextInput(session, "weight", value=input$weight)
  #   })
  # }
  
  
  # calcBMI <- reactive({
  #   input$weight
  #   
  # })
  
 

  
})






