
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
      h3("Enter the patient's current demographics below:"),
      
      # Gender Button
      radioButtons("GenderButton","Gender:", inline = TRUE,
                   choices = c("Male", "Female"),
                   selected = "Male"),

      #Patient's race
      radioButtons("RaceButton","Race:", inline = TRUE,
                   choices = c("White", "Non-White"),
                   selected = "White"),
      
      # Age Button
      sliderInput("PtAge", "Patient's Age:", min = 1, max = 100, value = 30),
      
      # Radio button for the type of surgery
      h4("What type of surgery will the patient have?"),
      radioButtons("SurgeryType","Surgery:", inline = FALSE,
                   choices = c("Pancreas", "stomach", "colon"),
                   selected = "Pancreas"),
      
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
