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
               textInput("height", "Height (cm):", value = "")
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
                          selected = "Fully Independent"),
             
             #Other medical problems
             radioButtons("OtherMedical","Other Medical Problems:", inline = FALSE,
                          choices = c("Totally Healthy", "Mild diseases", "Severe diseases", "Near death"),
                          selected = "Totally Healthy"),
             
             radioButtons("septic","Septic:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("vent","Ventilator:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("DMall","DMall:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("Dialysis","Dialysis:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons(inputId ="RenalFailure","Renal Failure:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("ascites","Ascites:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("steroids","Steroids:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No")
             )
         ),
  column(width = 4,
         box(width = NULL,
             h3("Cardiac & Respiratory Factors", align = "center"),
             
             radioButtons("Smoker","Smoker:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("SOB","Shortness of Breath:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("HxCHF","History of CHF:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("HxCOPD","History of COPD:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No"),
             
             radioButtons("HTNMeds","HTN Meds:", inline = TRUE,
                          choices = c("Yes", "No"),
                          selected = "No")
         ),
         
         box(width = NULL,
             h3("Surgery Profile", align = "center"),
             # Radio button for the type of surgery
             radioButtons("SurgeryTypeButton","Surgery:", inline = FALSE,
                          choices = c("Pancreas", "Stomach", "Colon")),
             
             radioButtons("GICancer","GI Cancer Surgery:", inline = TRUE,
                          choices = c("Cancer Surgery", "Benign disease"))
         ),
         actionButton("Submit", "Submit", width = '210px', icon("refresh"))
  )
)