
CalcMajorRisk <- function() {
  
  ###Calculate the Major Complication Risk
  anyComplRaw <- 0.00  #Make sure we're starting from 0
  anyComplRaw <- majorComp_sexFactor*dfMaster[1,'Sex']
  anyComplRaw <- anyComplRaw + majorComp_raceFactor*dfMaster[1,'Race']
  anyComplRaw <- anyComplRaw + majorComp_ageFactor*dfMaster[1, 'Age']
  #anyComplRaw <- anyComplRaw + dfMaster[1, 'Surgery']
  anyComplRaw <- anyComplRaw + switch(as.character(dfMaster[1, 'Surgery']),
                                      "Pancreas" = 0,
                                      "Stomach" = majorComp_GastRxnFactor,
                                      "Colon" = majorComp_ColonRxnFactor, majorComp_ColonRxnFactor)
  anyComplRaw <- anyComplRaw + majorComp_FunctionalFactor*dfMaster[1, 'Funcational']
  anyComplRaw <- anyComplRaw + majorComp_CancerGIFactor*dfMaster[1, 'Cancer']
  anyComplRaw <- anyComplRaw + majorComp_asaclassFactor*dfMaster[1, 'ASAClass']
  anyComplRaw <- anyComplRaw + majorComp_steroidFactor*dfMaster[1, 'Steroid']
  anyComplRaw <- anyComplRaw + majorComp_ascitesFactor*dfMaster[1, 'Ascites']
  anyComplRaw <- anyComplRaw + majorComp_SepticFactor*dfMaster[1, 'Septic']
  anyComplRaw <- anyComplRaw + majorComp_ventilarFactor*dfMaster[1, 'Vent']
  anyComplRaw <- anyComplRaw + majorComp_DMallFactor*dfMaster[1, 'DMAll']
  anyComplRaw <- anyComplRaw + majorComp_hypermedFactor*dfMaster[1, 'HTNMed']
  anyComplRaw <- anyComplRaw + majorComp_hxchfFactor*dfMaster[1, 'HxCHF']
  anyComplRaw <- anyComplRaw + majorComp_SOBFactor*dfMaster[1, 'SOB']
  anyComplRaw <- anyComplRaw + majorComp_smokerFactor*dfMaster[1, 'Smoker']
  anyComplRaw <- anyComplRaw + majorComp_hxcopdFactor*dfMaster[1, 'HxCOPD']
  anyComplRaw <- anyComplRaw + majorComp_dialysisFactor*dfMaster[1, 'Dialysis']
  anyComplRaw <- anyComplRaw + majorComp_renafailFactor*dfMaster[1, 'RenalFailure']
  anyComplRaw <- anyComplRaw + majorComp_BMIFactor*dfMaster[1, 'BMI']
  return(anyComplRaw + majorComp_consFactor)
  
}

CalcBaselineRisk <- function() {
  ###Calculate the Major Complication Risk
  anyComplRaw <- 0.00  #Make sure we're starting from 0
  anyComplRaw <- majorComp_sexFactor*dfMaster[1,'Sex']
  anyComplRaw <- anyComplRaw + majorComp_raceFactor*dfMaster[1,'Race']
  anyComplRaw <- anyComplRaw + majorComp_ageFactor*dfMaster[1, 'Age']
  #anyComplRaw <- anyComplRaw + dfMaster[1, 'Surgery']
  anyComplRaw <- anyComplRaw + switch(as.character(dfMaster[1, 'Surgery']),
                                      "Pancreas" = 0,
                                      "Stomach" = majorComp_GastRxnFactor,
                                      "Colon" = majorComp_ColonRxnFactor, majorComp_ColonRxnFactor)
  anyComplRaw <- anyComplRaw + majorComp_FunctionalFactor*dfMaster[1, 'Funcational']
  anyComplRaw <- anyComplRaw + majorComp_CancerGIFactor*dfMaster[1, 'Cancer']
  anyComplRaw <- anyComplRaw + majorComp_asaclassFactor*dfMaster[1, 'ASAClass']
  # anyComplRaw <- anyComplRaw + majorComp_steroidFactor*dfMaster[1, 'Steroid']
  anyComplRaw <- anyComplRaw + majorComp_ascitesFactor*dfMaster[1, 'Ascites']
  anyComplRaw <- anyComplRaw + majorComp_SepticFactor*dfMaster[1, 'Septic']
  anyComplRaw <- anyComplRaw + majorComp_ventilarFactor*dfMaster[1, 'Vent']
  # anyComplRaw <- anyComplRaw + majorComp_DMallFactor*dfMaster[1, 'DMAll']
  # anyComplRaw <- anyComplRaw + majorComp_hypermedFactor*dfMaster[1, 'HTNMed']
  # anyComplRaw <- anyComplRaw + majorComp_hxchfFactor*dfMaster[1, 'HxCHF']
  # anyComplRaw <- anyComplRaw + majorComp_SOBFactor*dfMaster[1, 'SOB']
  # anyComplRaw <- anyComplRaw + majorComp_smokerFactor*dfMaster[1, 'Smoker']
  # anyComplRaw <- anyComplRaw + majorComp_hxcopdFactor*dfMaster[1, 'HxCOPD']
  anyComplRaw <- anyComplRaw + majorComp_dialysisFactor*dfMaster[1, 'Dialysis']
  anyComplRaw <- anyComplRaw + majorComp_renafailFactor*dfMaster[1, 'RenalFailure']
  anyComplRaw <- anyComplRaw + majorComp_BMIFactor*20 #dfMaster[1, 'BMI']
  return(anyComplRaw + majorComp_consFactor)
}

CalcDeathRisk <- function() {

  ###Calculate risk of death
  anyComplRaw <- 0.00  #Make sure we're starting from 0
  anyComplRaw <- death_sexFactor*dfMaster[1,'Sex']
  anyComplRaw <- anyComplRaw + death_raceFactor*dfMaster[1,'Race']
  anyComplRaw <- anyComplRaw + death_ageFactor*dfMaster[1, 'Age']
  #anyComplRaw <- anyComplRaw + dfMaster[1, 'Surgery']
  anyComplRaw <- anyComplRaw + switch(as.character(dfMaster[1, 'Surgery']),
                                      "Pancreas" = 0,
                                      "Stomach" = death_GastRxnFactor,
                                      "Colon" = death_ColonRxnFactor, death_ColonRxnFactor)
  anyComplRaw <- anyComplRaw + death_FunctionalFactor*dfMaster[1, 'Funcational']
  anyComplRaw <- anyComplRaw + death_CancerGIFactor*dfMaster[1, 'Cancer']
  anyComplRaw <- anyComplRaw + death_asaclassFactor*dfMaster[1, 'ASAClass']
  anyComplRaw <- anyComplRaw + death_steroidFactor*dfMaster[1, 'Steroid']
  anyComplRaw <- anyComplRaw + death_ascitesFactor*dfMaster[1, 'Ascites']
  anyComplRaw <- anyComplRaw + death_SepticFactor*dfMaster[1, 'Septic']
  anyComplRaw <- anyComplRaw + death_ventilarFactor*dfMaster[1, 'Vent']
  anyComplRaw <- anyComplRaw + death_DMallFactor*dfMaster[1, 'DMAll']
  anyComplRaw <- anyComplRaw + death_hypermedFactor*dfMaster[1, 'HTNMed']
  anyComplRaw <- anyComplRaw + death_hxchfFactor*dfMaster[1, 'HxCHF']
  anyComplRaw <- anyComplRaw + death_SOBFactor*dfMaster[1, 'SOB']
  anyComplRaw <- anyComplRaw + death_smokerFactor*dfMaster[1, 'Smoker']
  anyComplRaw <- anyComplRaw + death_hxcopdFactor*dfMaster[1, 'HxCOPD']
  anyComplRaw <- anyComplRaw + death_dialysisFactor*dfMaster[1, 'Dialysis']
  anyComplRaw <- anyComplRaw + death_renafailFactor*dfMaster[1, 'RenalFailure']
  anyComplRaw <- anyComplRaw + death_BMIFactor*dfMaster[1, 'BMI']
  return(anyComplRaw + death_consFactor)
  
}

