
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
      
      sliderInput("bins",
                  "Patient's Age:",
                  min = 1,
                  max = 100,
                  value = 30),
      
      em("Emphasized Text")

    ),
    mainPanel(
      h3("Main Panel Text"),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("distPlot")
      )
     # code("Some Code!")
  ))
))
