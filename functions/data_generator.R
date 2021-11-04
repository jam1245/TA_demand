library(tidyverse)

# https://github.com/plotly/datasets/blob/master/us-cities-top-1k.csv

clear <- c("Top Secret", "Secret", "None", "TS/SCI", "TS/SCI w/Poly")
citytwo <- c("Hanover", "Moorestown", "other", "Syracuse", "Manassas", "Owego", "Annapolis", "Mount Laurel", "San Diego", "Uniondale", "Bothell",
  "Huntsville", "Washington", "Marion", "Fort Worth", "Camden", "Colorado Springs", "King of Prussia", "Eglin", "Littleton", "Clearwater", 
  "Glendale", "Baltimore", "Stratford", "Shelton", "Dallas", "Milwaukee", "Patuxent River") 

jobs <- c("Software Engineering", "Public Relations", "Finance", "Systems Engineering",  "Hardware Engineering", "Electrical Engineering", 
          "Manufacturing", "Systems Engineering: Requirements Development", "Chemical Engineering", "Systems Engineering: System of Systems Integration", 
          "Program Management", "Mechanical Engineering") 

job_category <- c("Experienced Professional", "4 yr and up College", "Hourly or NonExempt")

library(readr)
cities_us <- read_csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv")


city_simple <- cities_us %>%  
  head(120) 

# additional data gen
# 
lat <- city_simple$lat
long <- city_simple$lon
pop <- city_simple$pop


cleartwo <- rep(clear, 120, length.out = 120)
jobs_vector <- rep(jobs, 10)
length(jobs_vector)
city_vector <- rep(citytwo, 10, length_out = 120)
job_category_vec <- rep(job_category, 40, length_out = 120)
job_category_vec %>% length()
length(city_vector)
samp=seq(from=20,to=200,by=5)

df <- data.frame(x=sample(seq(from=10,to=200,by=5),size=120,replace=TRUE)) %>%
  mutate(LEVEL=sample(seq(from=1,to=8,by=1),size=120,replace=TRUE)) %>% 
  mutate(sourcing = rpois(120, 20)) %>%
  mutate(hiring_mngr_review = rpois(120, 4)) %>%
  mutate(interview = dnorm(x, mean = 5, sd=1) ) %>%
  mutate(offer_pending = dnorm(x, mean = 10, sd =2)) %>%
  mutate(offer_to_accept = dnorm(x, mean = 15, sd =3)) %>%
  mutate(Clearance = cleartwo) %>%
  mutate(JOB_CLASS = jobs_vector) %>%
  mutate(JOB_CATEGORY = job_category_vec) %>%
  mutate(cycletime = rnorm(120, mean = 40, sd = 10)) %>%
  mutate(avg_cycletime = rnorm(120, mean = 45, sd = 16)) %>%
  mutate(median_cycletime.x = rnorm(120, mean = 35, sd = 4)) %>%
  # categorical values 
  mutate(city_simple = city_simple$name) %>%
  mutate(lat = lat) %>%
  mutate(long = long)%>%
  mutate(pop = pop)

df %>% glimpse()
df %>% summary()

#https://github.com/plotly/datasets/blob/master/us-cities-top-1k.csv

## 










