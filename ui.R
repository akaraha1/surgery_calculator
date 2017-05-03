
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(leaflet)
library(ggplot2)
library(shinyjs)



dashboardPage(
  dashboardHeader(title = "Surgery Risk Predictor", titleWidth = 250),
  dashboardSidebar(
    sidebarMenu(style = "position: fixed; overflow: visible;", id = "tab",
      menuItem("Patient Questionnaire", tabName = "predictor", icon = icon("medkit")),
      menuItem("Risk Prediction Viewer", tabName = "dataViewer", icon = icon("line-chart")),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", href = "https://github.com/akaraha1/surgery_calculator", icon = icon("github-alt"))
    )
  ),
  dashboardBody(useShinyjs(),
                tags$head(
                  includeCSS('www/style.css')
                ),
    tabItems(
      tabItem(tabName = "predictor",
              #Links to a separate file with the Questionaire UI setup
              source(file.path("QuestionaireTabUI.R"),  local = TRUE)$value
      ),
      tabItem(tabName = "dataViewer",
              fluidRow(
                column(width = 12,
                       tabBox(width = 12,
                              title = tagList(shiny::icon("gear"), "Risk Graphs"),
                              side = "right", height = "500px",
                         tabPanel("Tab1", "Tab content 1",
                                  plotOutput("riskPlot3")
                                  ),
                         tabPanel("Tab2",
                                  "Tab content 2",
                                  plotOutput("riskPlot2")  
                                  ),
                         tabPanel(id = "Tab3", 
                                  title = "Tab3",
                                  color = "olive",
                                  plotOutput("riskPlot")),
                         selected = "Tab3"
                        
                       ),
                       # box(width = NULL,
                       #     title = "Any Complications", background = "maroon", solidHeader = TRUE,
                       #     #  plotOutput("distPlot"),
                       #     
                       # ),
                       
                       fluidRow(width = 12,
                                box(width = 12,
                                  title = "Section Title", status = "warning", solidHeader = TRUE,
                                  valueBoxOutput("BMIBox"),
                                  valueBoxOutput("anyComplBox"),
                                  valueBoxOutput("generic1")
                                )
                       ),
                       #Modifiable Risk Factors
                       fluidRow(width = 12,
                                box(width = 12,
                                    title = "Modifiable Risk Factors", status = "info", solidHeader = TRUE,
                                #h3("", align = "center"),
                                helpText("The following are mofifiable risk factors which could improve you surgery risk profile", align = "center"),
                                         
                                # A static infoBox
                                valueBoxOutput("generic2"),
                                valueBoxOutput("generic3"),
                                valueBoxOutput("generic4")
                                )
                       ),
                       fluidRow(width=12,
                                htmlOutput("hp")
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