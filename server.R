
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate bins based on input$PtAge from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$PtAge + 1)

    #test comment ---1
    #new comment
    #sagwrh
    
    output$pred2 <- renderText({
      "some text"
    })
    
    #put the tab 2 text box data on tab 2
    output$out2 <- renderText(input$box2)
    
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
