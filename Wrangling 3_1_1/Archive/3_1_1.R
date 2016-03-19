#FDS Data Wrangling exercise 1

library(dplyr)
library(tidyr)

refine_original <- read.csv("~/FDS/Wrangling 3_1_1/refine_original.csv")

tolower(refine_original$company)