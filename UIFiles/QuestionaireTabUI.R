###Questionaire User Interface
## This file creates user interface for the questionaire page
## Questions are sorted into boxes by topics.

# Source the switch button function
#source("./UIFiles/SwitchButton.R")
source(file.path("UIFiles","SwitchButton.R"),  local = TRUE)$value

fluidRow(
  column(width = 4,
         box(width = NULL, align="center",
             h3("Basic Demographics", align = "center"),
             radioButtons("GenderButton","Gender:", inline = TRUE,
                          choices = c("Male", "Female"),
                          selected = "Male"),
             #Patient's race
             radioButtons("RaceButton","Race:", inline = TRUE,
                          choices = c("White", "Non-White"),
                          selected = "White"),
             # Age Button
             sliderInput("PtAge", "Patient's Age:", min = 18, max = 100, value = 50),
             helpText("Enter the patient's BMI."),  #BMI Section
             splitLayout(
               h5("BMI (kg/m2):", align = "center"),
               numericInput("BMI", label = NULL, value = 25.0, min = 0, max = 55, step = 0.1,
                            width = NULL)
             )             
         ),
         box(width = NULL,
             h3("Surgery Profile", align = "center"),
             # Radio button for the type of surgery
             radioButtons("SurgeryTypeButton","Surgery:", inline = FALSE,
                          choices = c("Gallbladder", "Colon", "Pancreas", "Stomach")),
             
             radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE,
                          choices = c("Benign disease", "Cancer Surgery"))
         )
  ),
  column(width = 4, 
         box(width = NULL, align="center",
             h3("Common Risk Factors", align = "center"),
             #Functional Status
             radioButtons("FunctionalStatus","Functional Status:", inline = FALSE,
                          choices = c("Totally Dependent", "Partially Dependent", "Fully Independent"),
                          selected = "Fully Independent"),
             #Other medical problems
             radioButtons("OtherMedical",
                          HTML(paste("Other Medical Problems:",
                                     "(ASA Class)", sep="<br/>")),
                          inline = FALSE,
                          choices = c("1: Totally Healthy", "2: Mild diseases", "3: Severe diseases", "4: Near death"),
                          selected = "1: Totally Healthy"),
             #Diabetes
             switchButton(inputId = "DMall",
                          label = "Diabetes mellitus:",
                          value = FALSE, col = "RG", type = "YN"),
             #Smoker
             switchButton(inputId = "Smoker",
                          label = "Smoker:",
                          value = FALSE, col = "RG", type = "YN"),
             #CHF
             switchButton(inputId = "HxCHF",
                          label = "History of CHF:",
                          value = FALSE, col = "RG", type = "YN"),
             #COPD
             switchButton(inputId = "HxCOPD",
                          label = "History of COPD:",
                          value = FALSE, col = "RG", type = "YN"),
             #HTN
             switchButton(inputId = "HTNMeds",
                          label = HTML(paste("Hyptension:",
                                             "(requiring medication)", sep="<br/>")),
                          value = FALSE, col = "RG", type = "YN")
             )
         ),
  column(width = 4,
         box(width = NULL, align="center",
             h3("Additional Risk Factors", align = "center"),
             
             #Septic
             switchButton(inputId = "septic",
                          label = "Septic:",
                          value = FALSE, col = "RG", type = "YN"),
             
             switchButton(inputId = "vent",
                          label = "Ventilator dependent:",
                          value = FALSE, col = "RG", type = "YN"),

             
             switchButton(inputId = "Dialysis",
                          label = "Currently on Dialysis:",
                          value = FALSE, col = "RG", type = "YN"),
             
             switchButton(inputId = "RenalFailure",
                          label = HTML(paste("Renal Failure:", "(Cr > 3 for 2 occurrences)", sep="<br/>")),
                          value = FALSE, col = "RG", type = "YN"),
             
             switchButton(inputId = "ascites",
                          label = "Ascites (clinical or imaging):",
                          value = FALSE, col = "RG", type = "YN"),
             
             switchButton(inputId = "steroids",
                          label = "Chronic Steroids:",
                          value = FALSE, col = "RG", type = "YN"),
             
             switchButton(inputId = "SOB",
                          label = "Shortness of Breath:",
                          value = FALSE, col = "RG", type = "YN")
  
         ),
         actionButton("Submit", "Submit", width = '210px', icon("refresh"))
  )
)
