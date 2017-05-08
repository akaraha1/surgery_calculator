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

##Show functional Status Box if applicable
output$FunctStatusBox <- renderUI({
  if(functStatus < 2) {#if the person is less than fully independent
    tmpRisk <- anyComplRaw - FunctionalFactor*functStatus + FunctionalFactor*2
    newRisk <- calcRiskFinal(tmpRisk) - calcRiskFinal(anyComplRaw) 
    
    valueBox(
      paste0(formatC(newRisk, digits = 1, format = "f"), "%"),
      "Functional Status Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})


##Show Sterioid Status Box if applicable
output$SteroidBox <- renderUI({
  if(steroidStatus == 1) {#if steroids == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - steroidFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "Steroid Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show CHF Status Box if applicable
output$CHFBox <- renderUI({
  if(CHFStatus == 1) {#if CHF status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - hxchfFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "CHF Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show SOB Status Box if applicable
output$SOBBox <- renderUI({
  if(SOBStatus == 1) {#if SOB status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - SOBFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "SOB Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show COPD Status Box if applicable
output$COPDBox <- renderUI({
  if(COPDStatus == 1) {#if COPD status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - hxcopdFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "COPD Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show Smoker Status Box if applicable
output$smokerBox <- renderUI({
  if(SmokerStatus == 1) {#if Smoking status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - smokerFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "Smoking Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show Diabetic Status Box if applicable
output$DMBox <- renderUI({
  if(DMStatus == 1) {#if Smoking status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - DMallFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "Diabetic Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

##Show HTN Status Box if applicable
output$HTNBox <- renderUI({
  if(HTNStatus == 1) {#if Smoking status == yes
    riskChange <- calcRiskFinal(anyComplRaw) - calcRiskFinal(anyComplRaw - hypermedFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "Hypertension Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

