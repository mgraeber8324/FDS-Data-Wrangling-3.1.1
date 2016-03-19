#FDS Data Wrangling exercise 1

library(dplyr)
library(tidyr)

refine_original <- read.csv("~/FDS/Wrangling 3_1_1/refine_original.csv")

#edit company names
colower <- tolower(refine_original$company)
phil1 <- sub("philips","phillips",colower,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) 
phil2 <- sub("phllips","phillips",phil1,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) 
phil3 <- sub("phillps","phillips",phil2,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) 
phil4 <- sub("phlips","phillips",phil3,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE) 
phil5 <- sub("fillips","phillips",phil4,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
akzo1 <- sub("akz0","akzo",phil5,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
akzo2 <- sub("ak zo","akzo",akzo1,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
company <- sub("unilver","unilever",akzo2,ignore.case = FALSE, perl = FALSE, fixed = FALSE, useBytes = FALSE)

#data frame with clean company vector
clean_co <- data.frame(company,refine_original[2:5])

#separate prduct code and #
sep_code_num <- separate(clean_co,Product.code...number,c("code","number"),sep = "-")

#create code_decipher dataframe
code <- c("p","v","x","q")
category <-  c("Smartphone","TV","Laptop","Tablet")
code_deciper <- data.frame(code,category)

#add category to dataframe
deciphered <- left_join(sep_code_num,code_deciper,by = "code")

#geo column
geo_mapper <- unite(deciphered,address,address,city,country,sep = ",",remove = TRUE)

#binary columns
#companies
company_phillips <- c(1,0,0,0)
company_akzo <- c(0,1,0,0)
company_van_houten <- c(0,0,1,0)
company_unilever <- c(0,0,0,1)
company <- c("phillips","akzo","van houten","unilever")
phillips01 <- data.frame(company,company_phillips)
akzo01 <- data.frame(company,company_akzo)
van_houten01 <- data.frame(company,company_van_houten)
unilever01 <- data.frame(company,company_unilever)

#products
product_smartphone <- c(1,0,0,0)
product_TV <- c(0,1,0,0)
product_laptop <- c(0,0,1,0)
product_tablet <- c(0,0,0,1)
smartphone01 <- data.frame(category,product_smartphone)
TV01 <- data.frame(category,product_TV)
laptop01 <- data.frame(category,product_laptop)
tablet01 <- data.frame(category,product_tablet)

#join company_ and product_ dataframes as columns to cleaned data
coph <- left_join(geo_mapper,phillips01,by = "company")
coak <- left_join(coph,akzo01,by = "company")
covh <- left_join(coak,van_houten01,by = "company")
coun <- left_join(covh,unilever01,by = "company")
prsp <- left_join(coun,smartphone01,by = "category")
prtv <- left_join(prsp,TV01,by = "category")
prlp <- left_join(prtv,laptop01,by = "category")
prtb <- left_join(prlp,tablet01,by = "category")
View(prtb)

write.csv(prtb,file = "~/FDS/Wrangling 3_1_1/refine_clean.csv")