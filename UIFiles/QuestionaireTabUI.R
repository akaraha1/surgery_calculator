###Questionaire User Interface
## This file creates user interface for the questionaire page
## Questions are sorted into boxes by topics.


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
             helpText("Enter the patient's Height/Weight or BMI."),
             # splitLayout(
             #   textInput("weight", "Weight (kg):", value = ""),
             #   textInput("height", "Height (cm):", value = "")
             # ),
             numericInput("BMI", "BMI (kg/m2):", value = 20, min = 0, max = 55, step = 1,
                          width = NULL)
             
             # textInput("BMI", "BMI (kg/m2):", value = "")
         ),
         box(width = NULL,
             h3("Surgery Profile", align = "center"),
             # Radio button for the type of surgery
             radioButtons("SurgeryTypeButton","Surgery:", inline = FALSE,
                          choices = c("Pancreas", "Stomach", "Colon")),
             
             radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE,
                          choices = c("Cancer Surgery", "Benign disease"))
         )
  ),
  column(width = 4,
         box(width = NULL,
             h3("Common Risk Factors", align = "center"),
             
             #Functional Status
             radioButtons("FunctionalStatus","Functional Status:", inline = FALSE,
                          choices = c("Totally Depdendent", "Partially Dependent", "Fully Independent"),
                          selected = "Fully Independent"),
             
             #Other medical problems
             radioButtons("OtherMedical",
                          HTML(paste("Other Medical Problems:",
                                     "(ASA Class)", sep="<br/>")),
                          inline = FALSE,
                          choices = c("1: Totally Healthy", "2: Mild diseases", "3: Severe diseases", "4: Near death"),
                          selected = "1: Totally Healthy"),
             
             #DM All
             radioButtons("DMall","Diabetes mellitus:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"), 
             
             #Smoker
             radioButtons("Smoker","Smoker:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             #CHF
             radioButtons("HxCHF","History of CHF:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"), 
             #COPD
             radioButtons("HxCOPD","History of COPD:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             #HTN
             radioButtons("HTNMeds",
                          HTML(paste("Hyptension:",
                                     "(requiring medication)", sep="<br/>")),
                          inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No")
             
             )
         ),
  column(width = 4,
         box(width = NULL,
             h3("Additional Risk Factors", align = "center"),
             
             radioButtons("septic","Septic:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("vent","Ventilator dependent:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("Dialysis","Currently on Dialysis:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons(inputId ="RenalFailure",
                          HTML(paste("Renal Failure:", "(Cr > 3 for 2 occurrences)", sep="<br/>")),
                          inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("ascites","Ascites (clinical or imaging):", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("steroids","Chronic Steroids:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("SOB","Shortness of Breath:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No")
         ),
         actionButton("Submit", "Submit", width = '210px', icon("refresh"))
  )
)
