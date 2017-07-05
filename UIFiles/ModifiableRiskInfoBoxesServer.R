###Modifiable Risk Factors
## This file creates infoboxes with the modifiable risk factors as applicable.
## They are only visiable if the risk is present and in the order of greatest
## risk contribution to least risk contribution

##Risk Contribution Order
# Functional Status
# Steroids
# CHF
# SOB
# COPD
# smoker
# DM
# HTN

withProgress(message = 'Calculting Modifiable Risk', value = 0, {

##Show functional Status Box if applicable
output$FunctStatusBox <- renderUI({
  if(dfRiskChanges[,'Funcational'] != -1) {#if the person is less than fully independent
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'Funcational']*-1, digits = 1, format = "f"), "%"),
      "Functional Status",
      icon = icon("list"),
      color = "red"
    )
  }
})
incProgress(1/8)

##Show Sterioid Status Box if applicable
output$SteroidBox <- renderUI({
  if(dfRiskChanges[,'Steroid'] != -1) {#if steroids == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'Steroid'], digits = 1, format = "f"), "%"),
      "Steroid Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(2/8)

##Show CHF Status Box if applicable
output$CHFBox <- renderUI({
  if(dfMaster[1, 'HxCHF'] == 1) {#if CHF status == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HxCHF'], digits = 1, format = "f"), "%"),
      "CHF Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(3/8)

##Show SOB Status Box if applicable
output$SOBBox <- renderUI({
  if(dfMaster[1, 'SOB'] == 1) {#if SOB status == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'SOB'], digits = 1, format = "f"), "%"),
      "SOB Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(4/8)

##Show COPD Status Box if applicable
output$COPDBox1 <- renderUI({
  if(dfMaster[1, 'HxCOPD'] == 1) {#if COPD status == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HxCOPD'], digits = 1, format = "f"), "%"),
      "COPD Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(5/8)

##Show Smoker Status Box if applicable
output$smokerBox <- renderUI({
  if(dfMaster[1, 'Smoker'] == 1) {#if Smoking status == yes
     valueBox(
      paste0("+", formatC(dfRiskChanges[,'Smoker'], digits = 1, format = "f"), "%"),
      "Smoking Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(6/8)

##Show Diabetic Status Box if applicable
output$DMBox <- renderUI({
  if(dfMaster[1, 'DMAll'] == 1) {#if diabetic status == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'DMAll'], digits = 1, format = "f"), "%"),
      "Diabetic Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(7/8)

##Show HTN Status Box if applicable
output$HTNBox <- renderUI({
  if(dfMaster[1, 'HTNMed'] == 1) {#if Smoking status == yes
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HTNMed'], digits = 1, format = "f"), "%"),
      "Hypertension Risk",
      icon = icon("list"),
      color = "red"
    )
  }
})

output$BMIBOX <- renderGvis({
  if(dfMaster[1, 'BMI'] > 25) {
    gvisGauge(data.frame(Item='BMI',Value=dfMaster[1, 'BMI']),
              options=list(min=0,
                           max=55,
                           greenFrom=15,
                           greenTo=25,
                           yellowFrom=25,
                           yellowTo=35,
                           redFrom=35, redTo=55)
              )
    }
  })

})

