
# shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
# saveRDS(shiny_token, "shiny_app_token.rds")
# ss <- gs_new("10_read-write-private-sheet",
#              row_extent = n, col_extent = n, input = filler)
# ss$sheet_key # 1Fhan4CT5wTdLDmNoD89JvHeeTfQmKtHbTfIyd7G3a1k


# googlesheets::gs_auth(token = "shiny_app_token.rds")
# sheet_key <- "1Fhan4CT5wTdLDmNoD89JvHeeTfQmKtHbTfIyd7G3a1k"
# ss <- googlesheets::gs_key(sheet_key)


########## MAJOR COMPLICATION REGRESSION COEFFICENTS
sexFactor           <-  -0.0242882
raceFactor          <-   0.0596692
ageFactor           <-   0.0028318
GastRxnFactor       <-  -0.5105275
ColonRxnFactor      <-  -0.8071903
CancerGIFactor      <-   0.0870107
FunctionalFactor    <-  -0.5353748
asaclassFactor      <-   0.4420653  
steroidFactor       <-   0.4215457   
ascitesFactor       <-   0.7761558  
SepticFactor        <-   0.7766535  
ventilarFactor      <-   0.904599   
DMallFactor         <-   0.0697649  
hypermedFactor      <-   0.0406726   
hxchfFactor         <-   0.2994934
SOBFactor           <-   0.2186209   
smokerFactor        <-   0.1309884   
hxcopdFactor        <-   0.2158972   
dialysisFactor      <-   0.1193262     
renafailFactor      <-   0.3735297 
BMIFactor           <-   0.0094137
consFactor          <-  -1.761664 

