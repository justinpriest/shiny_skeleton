library(tidyverse)
library(lubridate)
library(shinythemes)

testdata <- read_csv("hughsmith.csv") %>%
  rename("obs_date" = `Obs Date`) %>%
  mutate(obs_date = as_date(obs_date, format = "%m/%d/%Y"),
         std_date = as_date(paste0(2021, "-",month(obs_date), "-", day(obs_date))),
         jday = yday(std_date)) %>%
  filter(Year >= 1990, Maturity != "Smolt",
         jday > 170) 


catchsumm <- testdata %>% group_by(Year) %>%
  summarise(AnnualCount = sum(Count, na.rm = TRUE)) %>%
  mutate(Year = as.integer(Year),
         AnnualCount = as.integer(AnnualCount))





########## Load a different dataset 
mtadata <- read_csv("mtalenweight.csv") %>%
  filter(!is.na(Oto_length), !is.na(Fish_weight))
  #dplyr::distinct(Sample_ID, .keep_all = TRUE) # multiple measurements of same sample

modlm <- lm(log(Fish_weight) ~ log(Fish_length), data = mtadata)

a <- exp(coef(modlm)[1]) %>% as.vector()
b <- coef(modlm)[2] %>% as.vector()
pred <- (a * (seq(from=1, to=800) ^ b))

# Now for uncertainty
syx <- summary(modlm)$sigma
(cf <- exp((syx^2)/2))# this is the bias correction factor
#http://derekogle.com/fishR/examples/oldFishRVignettes/LengthWeight.pdf

mtadata$lenwtfit <- ((predict(modlm, data.frame(Fish_length = mtadata$Fish_length), interval="p")) %>% exp() * cf)[,"fit"]
mtadata$lenwtlow <- ((predict(modlm, data.frame(Fish_length = mtadata$Fish_length), interval="p")) %>% exp() * cf)[,"lwr"]
mtadata$lenwt_hi <- ((predict(modlm, data.frame(Fish_length = mtadata$Fish_length), interval="p")) %>% exp() * cf)[,"upr"]

mtadata <- mtadata %>% 
  mutate(outlier = if_else(Fish_weight >= lenwtlow & Fish_weight <= lenwt_hi,
                           "keep", "outlier"))




