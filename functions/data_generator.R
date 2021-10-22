library(tidyverse)

# https://github.com/plotly/datasets/blob/master/us-cities-top-1k.csv

clear <- c("Top Secret", "Secret", "None", "TS/SCI", "TS/SCI w/Poly")
citytwo <- c("Hanover", "Moorestown", "other", "Syracuse", "Manassas", "Owego", "Annapolis", "Mount Laurel", "San Diego", "Uniondale", "Bothell",
  "Huntsville", "Washington", "Marion", "Fort Worth", "Camden", "Colorado Springs", "King of Prussia", "Eglin", "Littleton", "Clearwater", 
  "Glendale", "Baltimore", "Stratford", "Shelton", "Dallas", "Milwaukee", "Patuxent River") 

jobs <- c("Software Engineering", "Public Relations", "Finance", "Systems Engineering",  "Hardware Engineering", "Electrical Engineering", 
          "Manufacturing", "Systems Engineering: Requirements Development", "Chemical Engineering", "Systems Engineering: System of Systems Integration", 
          "Program Management", "Mechanical Engineering") 

cities_us <- read_csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv")


city_simple <- cities_us %>%  
  head(120) 

lat <- city_simple$lat
long <- city_simple$lon
pop <- city_simple$pop


cleartwo <- rep(clear, 120, length.out = 120)
jobs_vector <- rep(jobs, 10)
length(jobs_vector)
city_vector <- rep(citytwo, 10, length_out = 120)
length(city_vector)

df1 <- data.frame(x=sample(seq(from=10,to=200,by=5),size=120,replace=TRUE)) %>%
  mutate(LEVEL=sample(seq(from=1,to=8,by=1),size=120,replace=TRUE)) %>% 
  mutate(sourcing = rpois(120, 20)) %>%
  mutate(hiring_mngr_review = rpois(120, 4)) %>%
  mutate(interview = dnorm(x, mean = 5, sd=1) ) %>%
  mutate(offer_pending = dnorm(x, mean = 10, sd =2)) %>%
  mutate(offer_to_accept = dnorm(x, mean = 15, sd =3)) %>%
  mutate(Clearance = cleartwo) %>%
  mutate(JOB_CLASS = jobs_vector) %>%
  mutate(avg_cycletime = 40) %>%
  mutate(cycletime = dnorm(x, mean = 40, sd =10)) %>%
  # categorical values 
  mutate(city_simple = city_simple$name) %>%
  mutate(lat = lat) %>%
  mutate(long = long)%>%
  mutate(pop = pop)

df1 %>% glimpse()

https://github.com/plotly/datasets/blob/master/us-cities-top-1k.csv








city_simple
Clearance
JOB_CLASS
avg_cycletime

cycletime ~ 
  city_simple + 
  JOB_CATEGORY + 
  JOB_CLASS +
  sourcing +
  hiring_mngr_review+
  interview+
  offer_pending+
  offer_to_accept+ 
  Clearance +
  LEVEL,

median_cycletime.x
city
state
long
lat

data.frame(JOB_CATEGORY = input$JOB_category_staffing,
           LEVEL = input$level_staffing,
           JOB_CLASS = input$JOB_class_staffing,
           city_simple=input$city_name, 
           sourcing = input$sourcing, 
           hiring_mngr_review = input$hiring_mngr_review, 
           interview = input$interview,
           offer_pending = input$offer_pending, 
           offer_to_accept = input$offer_to_accept,
           Clearance = input$Clearance_staffing)





library(lubridate)

start_date <- as.Date("1980/01/01") 

seq(start_date, by = "day", )


days <- seq(ymd("1904-1-1"), today(), by = "day")

date_tbl <- tibble(day = days) %>% 
  mutate(year = year(day)) %>%
  mutate(month = month(day)) %>% 
  mutate(month_name = months(day)) %>%
  mutate(month_end_date = ceiling_date(day, "month") - days(1)) %>% 
  mutate(quarter = quarter(day)) %>%
  mutate(fiscal_yr_qtr = quarter(day, with_year = TRUE, fiscal_start = 8)) %>%
  mutate(fiscal_qtr = quarter(day, with_year = FALSE, fiscal_start = 8)) %>%
  mutate(semester_yr = semester(day, with_year = TRUE)) %>%
  mutate(semester = semester(day, with_year = FALSE))
  
glimpse(day_tbl)








