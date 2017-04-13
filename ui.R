
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
                column(width = 8,
                       box(width = NULL,
                           h3("Day of the Week with the Most Crime")
                       )
                )
                
              )
      ),
      tabItem(tabName = "about",
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           h3("Day of the Week with the Most Crime")))#includeMarkdown("about.md")))
              )
      )
    )
  )
)