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
  if(dfRiskChanges[,'Funcational'] != -1) {#if the person is less than fully independent
    print("in here funct")
    insertUI(selector = '#FunctStatusBoxPlaceholder', ui = tags$div(
      output$FunctStatusBox <- renderUI({
          valueBox(
            paste0("+", formatC(dfRiskChanges[,'Funcational']*-1, digits = 1, format = "f"), "%"),
            "Functional Status",
            icon = icon("list"),
            color = "red"
          )
        })
      )
  )
  }
  

incProgress(1/8)

##Show Sterioid Status Box if applicable

  if(dfRiskChanges[,'Steroid'] != -1) {#if steroids == yes
    print("in steroid box")
    insertUI(selector = '#SteroidBoxPlaceholder', ui = tags$div(
      output$SteroidBox <- renderUI({
        valueBox(
      paste0("+", formatC(dfRiskChanges[,'Steroid'], digits = 1, format = "f"), "%"),
      "Steroid Risk Contribution",
      icon = icon("list"),
      color = "red")
  })
  )
)
}

incProgress(2/8)

##Show CHF Status Box if applicable
if(dfMaster[1, 'HxCHF'] == 1) {#if CHF status == yes
  print("in CHF box")
  insertUI(selector = '#CHFBoxPlaceholder', ui = tags$div(
    output$CHFBox <- renderUI({
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HxCHF'], digits = 1, format = "f"), "%"),
      "CHF Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
    })
  ) 
  )
}

incProgress(3/8)

##Show SOB Status Box if applicable
if(dfMaster[1, 'SOB'] == 1) {#if SOB status == yes
  print("in SOB box")
  insertUI(selector = '#SOBBoxPlaceholder', ui = tags$div(
    output$SOBBox <- renderUI({
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'SOB'], digits = 1, format = "f"), "%"),
      "SOB Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  })
  )
  )
}

incProgress(4/8)

##Show COPD Status Box if applicable
if(dfMaster[1, 'HxCOPD'] == 1) {#if COPD status == yes
  
  print("in COPD box")
  insertUI(selector = '#COPDBox1Placeholder', ui = tags$div(
    output$COPDBox1 <- renderUI({
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HxCOPD'], digits = 1, format = "f"), "%"),
      "COPD Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  })))
}

incProgress(5/8)

##Show Smoker Status Box if applicable
if(dfMaster[1, 'Smoker'] == 1) {#if Smoking status == yes
  print("in Smoker box")
  insertUI(selector = '#smokerBoxPlaceholder', ui = tags$div(
    output$smokerBox <- renderUI({
     valueBox(
      paste0("+", formatC(dfRiskChanges[,'Smoker'], digits = 1, format = "f"), "%"),
      "Smoking Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  })))
}

incProgress(6/8)

##Show Diabetic Status Box if applicable
if(dfMaster[1, 'DMAll'] == 1) {#if diabetic status == yes
  print("in DM all box")
  insertUI(selector = '#DMBoxPlaceholder', ui = tags$div(
output$DMBox <- renderUI({
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'DMAll'], digits = 1, format = "f"), "%"),
      "Diabetic Risk Contribution",
      icon = icon("list"),
      color = "red"
    )
  })))
}

incProgress(7/8)



##Show HTN Status Box if applicable
if(dfMaster[1, 'HTNMed'] == 1) {#if Smoking status == yes
  
print("in HTN box")
insertUI(selector = '#HTNBoxPlaceholder', ui = tags$div(
  
output$HTNBox <- renderUI({
    valueBox(
      paste0("+", formatC(dfRiskChanges[,'HTNMed'], digits = 1, format = "f"), "%"),
      "Hypertension Risk",
      icon = icon("list"),
      color = "red"
    )
  })))
}

  if(dfMaster[1, 'BMI'] > 25) {
    output$BMIBOX <- renderGvis({

        gvisGauge(data.frame(Item='BMI',Value=dfMaster[1, 'BMI']),
                  options=list(min = 0,
                               max = 55,
                               greenFrom = 15,
                               greenTo = 25,
                               yellowFrom = 25,
                               yellowTo = 35,
                               redFrom = 35,
                               redTo = 55)
                  ) 
    })
    }
})



####Work on this
# #Remove old UI's if applicable
# removeUI(selector = paste0('#', "FunctStatusBoxPlaceholder"))
