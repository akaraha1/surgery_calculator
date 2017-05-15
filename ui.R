
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
#library(leaflet)
#library(ggplot2)
library(shinyjs)

dashboardPage(
  dashboardHeader(title = "Surgery Risk Predictor", titleWidth = 250,
  # Dropdown menu for notifications
  dropdownMenu(type = "tasks", badgeStatus = "success",
               taskItem(value = 90, color = "green",
                        "Test 1"
               ),
               taskItem(value = 17, color = "aqua",
                        "Test 2"
               ),
               taskItem(value = 75, color = "yellow",
                        "Test 3 "
               ),
               taskItem(value = 80, color = "red",
                        "Overall"
               ),
               messageItem(
                 from = "Sales Dept",
                 message = "Message 1."
               ),
               messageItem(
                 from = "New User",
                 message = "How do I register?",
                 icon = icon("question"),
                 time = "13:45"
               ),
               messageItem(
                 from = "Support",
                 message = "The new server is ready.",
                 icon = icon("life-ring"),
                 time = "2014-12-01"
               )
  )
  ),
  dashboardSidebar(
    sidebarMenu(style = "position: fixed; overflow: visible;", id = "tab",
      menuItem("Patient Questionnaire", tabName = "predictor", icon = icon("medkit")),
      menuItem("Risk Prediction Viewer", tabName = "dataViewer", icon = icon("dashboard")),
      sidebarMenuOutput("SaveFeature"),
      menuItem("Save Data", icon = icon("check-circle", lib = "font-awesome"), tabName = "tabOne",
               # Input directly under menuItem
               textInput("PtID", "Pt ID:", width = '98%'),
               
               
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
                                  title = "Predicted Clinical Outcomes", status = "warning", solidHeader = TRUE,
                                  valueBoxOutput("majorComplicationBox"),
                                  valueBoxOutput("deathRiskBox")
                                )
                       ),
                       #Modifiable Risk Factors
                       fluidRow(width = 12,
                                box(width = 12,
                                    title = "Modifiable Risk Factors", status = "info", solidHeader = TRUE,
                                #h3("", align = "center"),
                                helpText("The following are mofifiable risk factors which could improve you surgery risk profile", align = "center"),
                                uiOutput("FunctStatusBox"),
                                uiOutput("SteroidBox"),
                                uiOutput("CHFBox"),
                                uiOutput("SOBBox"),
                                uiOutput("COPDBox"),
                                uiOutput("smokerBox"),
                                uiOutput("DMBox"),
                                uiOutput("HTNBox")
                                )
                       ),
                       fluidRow(width=12,
                                htmlOutput("hp")
                                #actionButton("submitToGoogle", "Submit to Google", class = "btn-primary")
                                
                       )
                )
              )),
 
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           includeMarkdown("about.md")
                           )
                       )
                )
              )
      )
  )
)




# conditionalPanel(
#   condition = c("input.FunctionalStatus == 'Totally Depdendent'",
#                 "input.FunctionalStatus == 'Partially Dependent'",
#                 "input.FunctionalStatus == 'Fully Independent'"
#                 ),
#   selectInput("smoothMethod", "Method",
#               list("lm", "glm", "gam", "loess", "rlm"))
# ),