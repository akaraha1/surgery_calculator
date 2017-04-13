
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Surgery Risk Calculator"),

  
  sidebarLayout(
    sidebarPanel(
      h1("Patient Demographics"),
      h3("H3 Text"),
      
      sliderInput("bins", "Patient's Age:", min = 1, max = 100, value = 30),
      
      em("Emphasized Text"),
      
      numericInput("numeric", "This is a numeric input.", 
                   value = 20, min = 1, max = 100, step = 1),
      
      checkboxInput("checkBoxID", "check box input", value = TRUE),
      
      textInput("box2", "This value will appear on Tab 2:", value = "..."),
      
      

      submitButton("Submit")
      
      
    ),
    mainPanel(
      h3("Main Panel Text"),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("distPlot"),
        
        h3("Predicted value1:"),
        textOutput("pred2"),
        
        tabsetPanel(type = "tabs", 
                    tabPanel("Tab 1", br(), textOutput("out1")), 
                    tabPanel("Tab 2", br(), textOutput("out2"))
        )
        
        
      )
     # code("Some Code!")
  ))
))
