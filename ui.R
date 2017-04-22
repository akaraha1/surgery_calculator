
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)


dashboardPage(
  dashboardHeader(title = "Surgery Risk Predictor", titleWidth = 250),
  dashboardSidebar(
    sidebarMenu(style = "position: fixed; overflow: visible;", id = "tab",
      menuItem("Patient Questionnaire", tabName = "predictor", icon = icon("signal", lib = "glyphicon")),
      menuItem("Risk Prediction Viewer", tabName = "dataViewer", icon = icon("stats", lib = "glyphicon")),
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
                           h3("Basic Demograpghics", align = "center"),
                          
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
                           helpText("Enter the patient's Height/Weight or BMI.",
                                    "The program will calculate BMI if it isn't entered.",
                                    ""),                                    
                                    
                           splitLayout(
                             textInput("weight", "Weight (kg):", value = ""),
                             textInput("height", "Height (m):", value = "")
                           ),
                           textInput("BMI", "BMI (kg/m2):", value = "")
                           )
                       ),
                column(width = 4,
                       box(width = NULL,
                           h3("Overall Health", align = "center"),
                           
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
                           )),
                column(width = 4,
                       box(width = NULL,
                           h3("Cardiac & Respiratory Factors", align = "center"),
                           
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
                           h3("Surgery Profile", align = "center"),
                           # Radio button for the type of surgery
                           radioButtons("SurgeryType","Surgery:", inline = FALSE,
                                        choices = c("Pancreas", "stomach", "colon"),
                                        selected = "Pancreas"),
                           
                           radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE,
                                        choices = c("Yes", "No"),
                                        selected = "No")
                       ),
                       actionButton("Submit", "Submit", width = '210px', icon("refresh"))
                       
                       #submitButton(width = '210px', "Submit", icon("refresh"))
                )

              )
      ),
      tabItem(tabName = "dataViewer",
              fluidRow(
                column(width = 8,
                       box(width = NULL,
                           title = "Any Complications", background = "maroon", solidHeader = TRUE,
                           #  plotOutput("distPlot"),
                           plotOutput("riskPlot")  
                           
                       ),
                       
                       fluidRow(width = 8,
                                # A static infoBox
                                valueBoxOutput("rate"),
<<<<<<< HEAD
                                infoBoxOutput("anyComplBox")
=======
                                infoBoxOutput("BMIBox")
>>>>>>> 8070fcee60c0ddfe4362e9e292eaf4eb0719335e
                       )
                       )
              )),
 
                       
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