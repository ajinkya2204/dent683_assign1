library(readxl)
nhanes_demo_12_18 <- read_excel("data/nhanes_demo_12_18.xlsx")
View(nhanes_demo_12_18)                                                       
library(readxl)
nhanes_ohx_12_18 <- read_excel("data/nhanes_ohx_12_18.xlsx")
View(nhanes_ohx_12_18)

install.packages("here")
library(here)

install.packages("tidyverse")
library(tidyverse)

library(dplyr)

data1<-nhanes_ohx_12_18 %>% filter(OHDDESTS==1, OHDEXSTS==1) %>%
  select("SEQN",ends_with("CTC"))

oh18<- read_excel(path = here("data/nhanes_ohx_12_18.xlsx"), sheet = "oh2018")

oh16<- read_excel(path = here("data/nhanes_ohx_12_18.xlsx"), sheet = "oh2016")

oh14<- read_excel(path = here("data/nhanes_ohx_12_18.xlsx"), sheet = "oh2014")

oh12<- read_excel(path = here("data/nhanes_ohx_12_18.xlsx"), sheet = "oh2012")

oh18_2<- oh18%>%filter(OHDDESTS==1, OHDEXSTS==1)%>%select("SEQN",ends_with("CTC"))

oh16_2<- oh16%>%filter(OHDDESTS==1, OHDEXSTS==1)%>%select("SEQN",ends_with("CTC")) 

oh14_2<- oh14%>%filter(OHDDESTS==1, OHDEXSTS==1)%>%select("SEQN",ends_with("CTC"))

oh12_2<- oh12%>%filter(OHDDESTS==1, OHDEXSTS==1)%>%select("SEQN",ends_with("CTC"))

mrg<- bind_rows(oh18_2,oh16_2,oh14_2,oh12_2)

table(duplicated(mrg$SEQN))

sheets_to_read<- readxl::excel_sheets("data/nhanes_demo_12_18.xlsx")
xall <- bind_rows(lapply(1:length(sheets_to_read),
                         function(i)readxl::read_excel("data/nhanes_demo_12_18.xlsx",
                                                       sheet = sheets_to_read[i]) %>%
                           mutate(tabname = sheets_to_read[i])))
colnames(xall)
names(xall)[names(xall)=="tabname"]<-"year"

xallnew <- xall%>%select("SEQN","year","RIDAGEYR")
View(xallnew)

xallyear <- xallnew

xallyear[xallyear=="demo2012"]<-"2012"
xallyear[xallyear=="demo2014"]<-"2014"
xallyear[xallyear=="demo2016"]<-"2016"
xallyear[xallyear=="demo2018"]<-"2018"
xallyear

finaldataset<-merge(mrg,xallyear, by="SEQN", all.x = F, all.y = F)

write_csv(finaldataset, here("data","18_oct_assign1"))
