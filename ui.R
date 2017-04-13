
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
                column(width = 12,
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
                           sliderInput("PtAge", "Patient's Age:", min = 1, max = 100, value = 30)
                       ),
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
                           h3("Section title 1"),
                           h4(textOutput("common_crime"))),
                       box(width = NULL,
                           h3("Section title 2"),
                           h4(textOutput("weekday_crime"))),
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