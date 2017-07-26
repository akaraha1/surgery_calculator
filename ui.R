
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(shinyjs)
library(plotly)
library(ggplot2)
library(markdown)

suppressPackageStartupMessages(library(googleVis))

dashboardPage(
  dashboardHeader(title = "Surgery Risk Predictor", titleWidth = 325),
  dashboardSidebar(
    sidebarMenu(style = "position: fixed; overflow: visible;", id = "tab",
      menuItem("Patient Questionnaire", tabName = "predictor", icon = icon("medkit")),
      menuItem("Risk Prediction Viewer", tabName = "dataViewer", icon = icon("dashboard")),
      sidebarMenuOutput("SaveFeature"),
      menuItem("Save Data", icon = icon("check-circle", lib = "font-awesome"), tabName = "tabOne",
               # Input inside of menuSubItem
               menuSubItem(icon = NULL,
                           actionButton("SavetoServer", "Submit To Server", width = '90%')
               )
      ),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", href = "https://github.com/akaraha1/surgery_calculator", icon = icon("github-alt"))
    )
  ),
  dashboardBody(useShinyjs(),
                tags$head(
                  includeCSS('www/style.css'),
                  includeCSS('www/button.css')
                ),
    tabItems(
      tabItem("tabOne",
              box(title = "Box One", 
                  width = 12,
                  height = "500px",
                  status = "success", 
                  solidHeader = TRUE, 
                  collapsible = TRUE,
                  verbatimTextOutput("boxOneText")
              )
      ),
      tabItem(tabName = "predictor",
              #Links to a separate file with the Questionaire UI setup
              source(file.path("UIFiles", "QuestionaireTabUI.R"),  local = TRUE)$value
      ),
      tabItem(tabName = "dataViewer",
              fluidRow(width = 12,
                       box(width = 12,
                           title = "Predicted Clinical Outcomes", solidHeader = TRUE,
                           tags$head(tags$style(HTML(".small-box {height: 120px}"))),
                           valueBoxOutput("majorComplicationBox"),
                           valueBoxOutput("deathRiskBox")
                       )
              ),
              #Modifiable Risk Factors
              fluidRow(width = 12,
                       box(width = 12,
                           title = "Modifiable Risk Factors", solidHeader = TRUE,
                           #h3("", align = "center"),
                           helpText("The following are mofifiable risk factors which could improve your surgery risk profile", align = "center"),
                           uiOutput("FunctStatusBox"),
                           uiOutput("SteroidBox"),
                           uiOutput("CHFBox"),
                           uiOutput("SOBBox"),
                           uiOutput("COPDBox1"),
                           uiOutput("smokerBox"),
                           uiOutput("DMBox"),
                           uiOutput("HTNBox"),
                           uiOutput("BMIBOX")
                       )
              ),
              # fluidRow(
              #   column(width = 12,
              #          div(id = "graph1Box-outer",
              #              box(id = "graph1Box",
              #                  width = NULL,
              #                  title = "Graph 1: Procedure Risk + Your Risk Contribution",
              #                  color = "gold",
              #                  actionButton("LoadGraph1", "Load Graph 1", width = '100%'),
              #                  plotOutput("riskPlot")
              #                  )
              #              )
              #          )
              # ),
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           title = "Graph: Procedure Risk + Your Risk Contribution",
                           color = "gold",
                           uiOutput("GraphSectionHeader"),
                           plotOutput("riskPlot2")
                       )
                )
              ),
              fluidRow(width = 12,
                       box(width = 12,
                           title = "Printable Report", solidHeader = TRUE,
                           radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'), inline = TRUE),
                           downloadButton('downloadReport')
                           )
                       )
              ),
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12, box(width = NULL, includeMarkdown("README.md"))
                       )
                )
              )
      )
  )
)

