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
  if(dfMaster[1, 'Funcational'] < 2) {#if the person is less than fully independent
    tmpRisk <- dfMaster[1,'Raw_MajorComplications'] - majorComp_FunctionalFactor*dfMaster[1, 'Funcational'] + majorComp_FunctionalFactor*2
    newRisk <- expMajorRisk(tmpRisk) - expMajorRisk(dfMaster[1,'Raw_MajorComplications']) 
    
    valueBox(
      paste0(formatC(newRisk*-1, digits = 1, format = "f"), "%"),
      "Functional Status Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})
incProgress(1/8)

##Show Sterioid Status Box if applicable
output$SteroidBox <- renderUI({
  if(dfMaster[1, 'Steroid'] == 1) {#if steroids == yes
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_steroidFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
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
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hxchfFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
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
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_SOBFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "SOB Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

incProgress(4/8)


##Show COPD Status Box if applicable
output$COPDBox <- renderUI({
  if(dfMaster[1, 'HxCOPD'] == 1) {#if COPD status == yes
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hxcopdFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
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
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_smokerFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
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
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_DMallFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
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
    riskChange <- dfMaster[1,'MajorComplications'] - expMajorRisk(dfMaster[1,'Raw_MajorComplications'] - majorComp_hypermedFactor)
    valueBox(
      paste0(formatC(riskChange, digits = 1, format = "f"), "%"),
      "Hypertension Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  }
})

})

