
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(
  dashboardHeader(title = "Surgery Risk Predictor", titleWidth = 250),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Surgery Risk Predictor", tabName = "predictor", icon = icon("signal", lib = "glyphicon")),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", href = "https://github.com/akaraha1/surgery_calculator", icon = icon("github-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "predictor",
              fluidRow(
                column(width = 4,
                       box(width = NULL,
                           h3("Basic Demograpghics"),
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
                       
                           #BMI Section
                           h5("Height/Weight OR BMI"),
                           splitLayout(
                             textInput("weight", "Weight (kg):", value = ""),
                             textInput("height", "Height (m):", value = "")
                           ),
                           textInput("BMI", "BMI (kg/m2):", value = "")),
                       
                       box(width = NULL,
                           h3("Surgery Profile"),
                           # Radio button for the type of surgery
                           radioButtons("SurgeryType","Surgery:", inline = FALSE,
                                        choices = c("Pancreas", "stomach", "colon"),
                                        selected = "Pancreas"),
                           
                           radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE,
                                        choices = c("Yes", "No"),
                                        selected = "No")
                           ),
                       box(width = NULL,
                           h3("Overall Health"),
                           
                           #Functional Status
                           radioButtons("FunctionalStatus","Functional Status:", inline = FALSE,
                                        choices = c("Totally Depdendent", "Partially Dependent", "Fully Independent"),
                                        selected = "Totally Depdendent"),
                           
                           #Other medical problems
                           radioButtons("OtherMedical","Other Medical Problems:", inline = FALSE,
                                        choices = c("Totally Healthy", "Mild diseases", "Severe diseases", "Near death"),
                                        selected = "Totally Healthy"),
                           
                           radioButtons("septic","Septic:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("vent","Ventilator:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("DMall","DMall:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("Dialysis","Dialysis:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("RenalFailure","Renal Failure:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("ascites","Ascites:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("steroids","Steroids:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No")
                           ),
                       box(width = NULL,
                           h3("Cardiac/Respiratory Factors"),
                           
                           radioButtons("Smoker","Smoker:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("SOB","Shortness of Breath:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("HxCHF","History of CHF:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("HxCHF","History of COPD:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No"),
                           
                           radioButtons("HTNMeds","HTN Meds:", inline = TRUE,
                                        choices = c("Yes ", "No"),
                                        selected = "No")
                           ),
                       box(width = NULL,
                           submitButton("Submit")
                       )
                ),
                column(width = 7, 
                       box(width = NULL,
                           plotOutput("distPlot"))
                )
              )
      ),
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           includeMarkdown("about.md")))
              )
      )
    )
  )
)