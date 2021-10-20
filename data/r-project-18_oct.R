library(readxl)
install.packages("here")
library(here)

install.packages("tidyverse")
library(tidyverse)

library(dplyr)

#####6.1 Import each sheet of these excel files as separate data sets in R

nhanes_demo_12_18 <- read_excel("data/nhanes_demo_12_18.xlsx")
View(nhanes_demo_12_18)                                                       

nhanes_ohx_12_18 <- read_excel("data/nhanes_ohx_12_18.xlsx")
View(nhanes_ohx_12_18)





##### 6.2 Create a single data set with the oral health examination data from all
##### the waves joined into a long format. This data set should only have data from
##### participants who completed an oral examination and only include variables 
##### related to id (SEQN), and crown caries (variables that end in CTC)

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


###6.3 To the demographic datasets, add a new variable year which takes the value 
###corresponding to the year of the survey.


demograph_12<- read_xlsx(here("data/nhanes_demo_12_18.xlsx"),sheet = "demo2012")
demograph_14<- read_xlsx(here("data/nhanes_demo_12_18.xlsx"),sheet = "demo2014")
demograph_16<- read_xlsx(here("data/nhanes_demo_12_18.xlsx"),sheet = "demo2016")
demograph_18<- read_xlsx(here("data/nhanes_demo_12_18.xlsx"),sheet = "demo2018")


demograph_year12<- demograph_12%>%mutate(year=2012)
demograph_year14<- demograph_14%>%mutate(year=2014)
demograph_year16<- demograph_16%>%mutate(year=2016)
demograph_year18<- demograph_18%>%mutate(year=2018)

###6.4 Create another data set with the demographic data from all the waves joined
###into a long format. This new data set should only have variables related to id (SEQN),
### year of survey(year), and age of the participant (RIDAGEYR)

dem_sel_12<- demograph_year12%>%select("SEQN","year","RIDAGEYR")
dem_sel_14<- demograph_year14%>%select("SEQN","year","RIDAGEYR")
dem_sel_16<- demograph_year16%>%select("SEQN","year","RIDAGEYR")
dem_sel_18<- demograph_year18%>%select("SEQN","year","RIDAGEYR")

demographymerge<- bind_rows(dem_sel_12,dem_sel_14,dem_sel_16,dem_sel_18)


##### 6.5 Merge the data sets created in step 6.2 and step 6.4 in to a single data set, 
##### ignoring those participants who are not present in both the data sets merged.

finalselected_dataset<-merge(mrg,demographymerge, by="SEQN", all.x = F, all.y = F)

write_csv(finalselected_dataset, here("data","19_oct_assign1"))


finalselected_dataset%>%group_by(year)%>%tally()



