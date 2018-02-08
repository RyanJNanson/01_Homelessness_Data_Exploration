# Homeless Data Processing
# Created: 06/12/17
# Author: CodeMonkey
# Explorer Location: \Desktop\CodeMonkeyBusiness\01_Homelessness

install.packages('ggplot2', dep = TRUE)
install.packages("beeswarm")

library(ggplot2)
library(beeswarm)

# Import dataset
homeless_dataset = read.csv('annual_rough_sleeping.csv',
                            stringsAsFactors=FALSE,
                            sep=","
                            )
household_dataset = read.csv('HouseholdAlone.csv',
                             stringsAsFactors=FALSE,
                             sep=","
                             )

# Explore the data
head(homeless_dataset)
head(household_dataset)

dim(homeless_dataset)
dim(household_dataset)

names(homeless_dataset)
names(household_dataset)

summary(homeless_dataset)
summary(household_dataset)

# Edit datasets for ease if use

# Change column names
names(homeless_dataset) <- c("id", "Area", "2010Homeless", "2011Homeless", "2012Homeless", "2013Homeless",
                             "2014Homeless", "2015Homeless", "2015HomesOriginal", "2015RateOringinal")
head(homeless_dataset)

names(household_dataset) <- c("id", "Area", "2010Houses", "2011Houses", "2012Houses", "2013Houses",
                             "2014Houses", "2015Houses")
head(household_dataset)

# Inner join to two datasets on "id"
mergedData = merge(household_dataset, homeless_dataset, by="id")

#Subset data on Area = "England" 
dataEngland=subset(mergedData, Area.x == "England")

#Create england data manually
homelessEngland = c(dataEngland[,'2010Homeless'], dataEngland[,'2011Homeless'],
                    dataEngland[,'2012Homeless'], dataEngland[,'2013Homeless'],
                    dataEngland[,'2014Homeless'], dataEngland[,'2015Homeless'])

homesEngland = c(dataEngland[,'2010Houses'], dataEngland[,'2011Houses'],
                    dataEngland[,'2012Houses'], dataEngland[,'2013Houses'],
                    dataEngland[,'2014Houses'], dataEngland[,'2015Houses'])

ratiosEngland = c(dataEngland[,'2010Homeless']/dataEngland[,'2010Houses'],
                  dataEngland[,'2011Homeless']/dataEngland[,'2011Houses'],
                  dataEngland[,'2012Homeless']/dataEngland[,'2012Houses'],
                  dataEngland[,'2013Homeless']/dataEngland[,'2013Houses'],
                  dataEngland[,'2014Homeless']/dataEngland[,'2014Houses'],
                  dataEngland[,'2015Homeless']/dataEngland[,'2015Houses'])

#Add years to plot on x-axis
years <- c("2010", "2011", "2012", "2013", "2014", "2015")

#Combine data into dataframe
englandData <-data.frame(years, homelessEngland, homesEngland, ratiosEngland)
type <- c(ratiosEngland)

#Plot dataframe years against homelessEngland
p <-ggplot(englandData, aes(years, homelessEngland))
p + geom_bar(stat = "identity", fill = '#4da4c6') + 
  labs(x= "Years", y="Estimated number of people", 
       title = "Rough sleeping across England",
       subtitle ="Estimated people sleeping rough in England a on single night",
       caption = "Source: http://opendata.cambridgeshireinsight.org.uk/dataset/homelessness-england") + 
  theme_grey()

#Plot dataframe years against homesEngland
p <-ggplot(englandData, aes(years, homesEngland))
p + geom_bar(stat = "identity", fill = '#4da4c6') + 
  labs(x= "Years", y="Estimated number houses", 
       title = "Number of Households",
       subtitle ="Predicted number of households across England",
       caption = "Source: https://www.gov.uk/government/statistical-data-sets/live-tables-on-household-projections") + 
  theme_grey()

#Plot dataframe years against ratiosEngland
p <-ggplot(englandData, aes(years, ratiosEngland))
p + geom_bar(stat = "identity", fill = '#4da4c6') + 
  labs(x= "Years", y="Ratio of rough sleepers per thousand homes", 
       title = "Rate of rough sleeping",
       subtitle ="Ratio of rough sleepers per thousand homes across England",
       caption = "Source: https://www.gov.uk/government/statistical-data-sets/live-tables-on-household-projections
       http://opendata.cambridgeshireinsight.org.uk/dataset/homelessness-england") + 
  theme_grey()

ratios = c(mergedData[,'2010Homeless']/mergedData[,'2010Houses'],
           mergedData[,'2011Homeless']/mergedData[,'2011Houses'],
           mergedData[,'2012Homeless']/mergedData[,'2012Houses'],
           mergedData[,'2013Homeless']/mergedData[,'2013Houses'],
           mergedData[,'2014Homeless']/mergedData[,'2014Houses'],
           mergedData[,'2015Homeless']/mergedData[,'2015Houses'])
