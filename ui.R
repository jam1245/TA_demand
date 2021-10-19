

# 1. Load Libraries -------------------------------------------------------------
source("library/library.R")

# 2. Load Data -------------------------------------------------------------
source("data/tidy_data.R")


# 3. Functions -------------------------------------------------------
source("/mnt/shiny_functions/shiny_functions.R")


# Define UI for application 
shinyUI(
  navbarPage("Talent Ingenium", theme = shinytheme("flatly"), collapsible = TRUE,

      # id = "tab_being_displayed", # will set input$tab_being_displayed
  tabPanel("Staffing Demand",
           tags$head(includeCSS("styles.css")),
           bootstrapPage(
             
             
             leafletOutput("map", height = 845), 
             absolutePanel(#top = 75, right = 10,
                           id = "logo", class = "card", top = 75, right = 10, width = 280, fixed=TRUE, draggable = FALSE, height = "auto",
                           tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='LM-logo.png',height='60',width='170')),
                           sliderInput("range", "Median Days Cycle Time", min(df$avg_cycletime), round(max(df$avg_cycletime), digits = 0),
                                       value = range(df$avg_cycletime), step = 0.1
                           ),tags$br(), 
                           selectInput("colors", "Color Scheme",
                                       rownames(subset(brewer.pal.info, category %in% c("seq", "div"))) #, selected = "Blues"
                           ),
                           checkboxInput("legend", "Show legend", FALSE)
             ),
            # absolutePanel(id = "logo", class = "card", bottom = 20, left = 60, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
            #               tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='LM-logo.png',height='60',width='170'))),
             
             absolutePanel(id = "controls", class = "panel panel-default",
                           top = 75, left = 55, width = 300, fixed=TRUE,
                           draggable = TRUE, height = "auto",
                           h3("Staffing Demand Genie", align = "left"),
                           span(tags$i(h6("Estimate the talent acquisition staffing hours required to hire new employees based on a variety of hiring scenarios including location, job characteristics, the number of new hires, and time involved in key hiring milestones.  Recruiter hours are estimated based on cycle time modeled predictions.")), style="color:#045a8d"),
                           h4(textOutput("total_staffing_hours"), align = "right"),
                           h5(textOutput("recruiters_hours"), align = "right"),
                           h6(textOutput("cycletime_pred"), align = "right"),
                           #             plotOutput("epi_curve", height="130px", width="100%"),
                           #             plotOutput("cumulative_plot", height="130px", width="100%"),
                           
                           selectInput("city_name", "City:", sort(unique(df$city_simple)), selected = "Washington"), 
                conditionalPanel("input.city_name !== null && input.city_name !== ''"),

                           selectInput("JOB_class_staffing", "Job Class:", sort(unique(sd_df$JOB_CLASS)), selected = "Software Engineering"),
                           selectInput("Clearance_staffing", "Clearance:", sort(unique(sd_df$Clearance)), selected = "None"),
                           selectInput("JOB_category_staffing", "Job Category:",
                                       c("4 yr and up College" = "4 yr and up College",
                                         "Experienced Professional" = "Experienced Professional",
                                  #       "Co-op/Intern" = "Co-op/Intern", 
                                         "Hourly/Non-Exempt" = "Hourly/Non-Exempt"
                                       ), selected = "Experienced Professional"),
                          numericInput("level_staffing", "Job Level", 3, min=1, max=7),
                          numericInput("Requistions", "Number of Requisitions", 10, min=1, max=100),

                          # sliderInput("Requistions", "Number of Requistions:", 1, 100, 10), 
                          # sliderInput("Recruiters", "Number of Recruiters:", 1, 50, 10), 
                          # sliderInput("sourcing", "Sourcing Days:", 1, 50, 20), 
                          # sliderInput("hiring_mngr_review", "Hiring Mngr Review:", 1, 30, 4), 
                          # sliderInput("interview", "Interview:", 1, 30, 4), 
                          # sliderInput("offer_pending", "Offer Pending Days:", 1, 30, 4), 
                          #sliderInput("offer_to_accept", "Offer to Accept Days:", 1, 30, 4)
                
            
                          numericInput("Recruiters", "Number of Recruiters", 5, min=1, max=50),
                          numericInput("sourcing", "Sourcing Days", 30, min=1, max=50),
                          numericInput("hiring_mngr_review", "Days for Hiring Manager Review", 4, min=1, max=50),
                          numericInput("interview", "Interview Period in Days", 4, min=1, max=50),
                          numericInput("offer_pending", "Offer Pending Period in Days", 2, min=1, max=50),
                          numericInput("offer_to_accept", "Offer to Accept in Days", 4, min=1, max=50)
                     #     submitButton("Update Calculations")
                
                
                
                           

                           
                           
             )
             ) ## bootstrap page 
           ), 
   ### Forecasting Applicataion Starts Here  

  tabPanel("About this site",
           tags$head(includeCSS("styles.css")),
           
           tags$h4("Background"), 
           "Talent Ingenium is designed to generate a variety of insights for RMS Integrated Talent Management (ITM)",tags$br(),
           "The aim of this site is to help leaders in RMS plan for a variety of talent acquisition scenarios.",tags$br(), tags$br(),
           "The Cycle Time App section is designed to assist GTA Leadership in aligning staffing resources to current hiring",tags$br(),           
           "needs and facilitate strategic and tactical hiring planning conversations between RMS managers and Talent Acquisition Employees.",tags$br(),  

           "The Staffing Demand app is designed to support GTA leadership when allocating recruiter time to a specific hiring scenarios.", tags$br(),
 #          "For example, where RMS may need twenty Software Engineers in Moorestown)",tags$br(),
           "The primary functionality in this application will estimate the staffing hours and total recruiter hours required to staff a specific hiring scenario",tags$br(),tags$br(),
           
           "This tool is designed to be used in combination with other reports and metrics as part of a larger view of the staffing organization.",tags$br(),
           "Additionally, this tool and GTA reporting in general is based on the assumption that users have a understanding of historical staffing",tags$br(),
           "activity and can speak to the presence of outliers and extreme cases in staffing data that may not be easily apparent in the current views.",tags$br(),

           
 #          tags$a(href="https://www.weblinkhere.com", "RMS Talent Acquistion"),tags$br(),
#           tags$a(href="https://gisanddata.maps.arcgis.com/", "Additional Web Link Placeholder"),tags$br(),
           
           tags$br(),tags$br(),tags$h4("Author"),
           "John Mataya, Data Science",tags$br(),
           tags$br(),tags$br(),tags$h4("Contact"),
           "johnmataya@gmail.com",tags$br(), 

           absolutePanel(id = "logo", class = "card", bottom = 20, left = 20, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
                       tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='LM-logo.png',height='90',width='250')))
           
  ),
  
  
  selected = "Staffing Demand"
  ) #end  navbarPage function 

  
)