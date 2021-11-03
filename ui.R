
# 1. PACKAGES -------------------------------------------------------------
source("functions/libraries.R")

# 2. Data -------------------------------------------------------------
source("functions/data_generator.R")



# Define UI for application 
shinyUI(
  navbarPage("Talent Ingenium", theme = shinytheme("flatly"), collapsible = TRUE,

      # id = "tab_being_displayed", # will set input$tab_being_displayed
  tabPanel("Staffing Demand",
           tags$head(includeCSS("styles.css")),
           bootstrapPage(
             
             
             leafletOutput("map", height = 845), 
             absolutePanel(
                           id = "logo", class = "card", top = 85, right = 10, width = 280, fixed=TRUE, draggable = FALSE, height = "auto",
                           tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='B-logo.png',height='60',width='170')),
                           sliderInput("range", "Median Days Cycle Time", round(min(df$avg_cycletime)), round(max(df$avg_cycletime), digits = 0),
                                       value = range(df$avg_cycletime), step = 5
                           ),tags$br(), 
                           selectInput("colors", "Color Scheme",
                                       rownames(subset(brewer.pal.info, category %in% c("seq", "div"))) , selected = "Blues"
                           ),
                           checkboxInput("legend", "Show legend", FALSE)
             ),
            # absolutePanel(id = "logo", class = "card", bottom = 20, left = 60, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
            #               tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='LM-logo.png',height='60',width='170'))),
             
             absolutePanel(id = "controls", class = "panel panel-default",
                           top = 75, left = 55, width = 375, fixed=TRUE,
                           draggable = TRUE, height = "auto",
                           tags$style(type='text/css', ".selectize-input { padding: 3px; min-height: 0; font-size: 10px; line-height: 11px;} 
 
                     .form-group, .shiny-input-container {padding: 3px; min-height: 0; font-size: 10px; line-height: 11px;}
                     
                     .irs-slider, single {font-size: 10px;}
                     .selectize-dropdown {font-size: 10px; line-height: 10px; }
                     .form-group, .selectize-control {margin-bottom:-1px;max-height: 90px !important;}
                     .box-body {padding-bottom: 0px;}
                     .form-control, shiny-bound-input {padding: 1px; min-height: 0; font-size: 10px; line-height: 11px; height: 25px;}
                               "),
                           h3("Staffing Demand Genie", align = "left"),
                           span(tags$i(h6("Estimate the talent acquisition staffing hours required to hire new employees based on a variety of hiring scenarios including location, job characteristics, the number of new hires, and time involved in key hiring milestones.  Recruiter hours are estimated based on cycle time modeled predictions.")), style="color:#045a8d"),
                           h4(textOutput("total_staffing_hours"), align = "right"),
                           h5(textOutput("recruiters_hours"), align = "right"),
                           h6(textOutput("cycletime_pred"), align = "right"),
                           #             plotOutput("epi_curve", height="130px", width="100%"),
                           #             plotOutput("cumulative_plot", height="130px", width="100%"),
                           
                           selectInput("city_name", "City:", sort(unique(df$city_simple)), selected = "Washington"), 
                conditionalPanel("input.city_name !== null && input.city_name !== ''"),

                           selectInput("JOB_class_staffing", "Job Class:", sort(unique(df$JOB_CLASS)), selected = "Software Engineering"),
                           selectInput("Clearance_staffing", "Clearance:", sort(unique(df$Clearance)), selected = "None"),
                           selectInput("JOB_category_staffing", "Job Category:",
                                       c("4 yr and up College" = "4 yr and up College",
                                         "Experienced Professional" = "Experienced Professional",
                                  #       "Co-op/Intern" = "Co-op/Intern", 
                                         "Hourly/Non-Exempt" = "Hourly/Non-Exempt"
                                       ), selected = "Experienced Professional"),
                          numericInput("level_staffing", "Job Level", 3, min=1, max=7),
                          numericInput("Requistions", "Number of Requisitions", 10, min=1, max=100),

                          numericInput("Recruiters", "Number of Recruiters", 5, min=1, max=50),
                          numericInput("sourcing", "Sourcing Days", 30, min=1, max=50),
                          numericInput("hiring_mngr_review", "Days for Hiring Manager Review", 4, min=1, max=50),
                          numericInput("interview", "Interview Period in Days", 4, min=1, max=50),
                          numericInput("offer_pending", "Offer Pending Period in Days", 2, min=1, max=50),
                          numericInput("offer_to_accept", "Offer to Accept in Days", 4, min=1, max=50)

                
                
                           

                           
                           
             )
             ) ## bootstrap page 
           ), 
   ### Forecasting Applicataion Starts Here  

  tabPanel("About this site",
           tags$head(includeCSS("styles.css")),
           
           tags$h4("Background"), 
           "Talent Ingenium is designed support Talent Acquisition leadership plan for a variety of hiring scenarios.",tags$br(),
           "Managers can use the application to estimate how many recruiter hours are needed to staff a specific hiring scenario.",tags$br(), tags$br(),
           "To estimate the amount of time it takes to onboard new talent in various parts of the country, managers can simply input",tags$br(),           
           "key variables and get on the fly predictions and estimates from a trained machine learning model.",tags$br(), tags$br(), 

           "Note: This application uses dumy data and is launched as a template for building a more robust application.", tags$br(),
 #          "For example, where RMS may need twenty Software Engineers in Moorestown)",tags$br(),
           "To leverage this application in an enterprise workflow, we recommend implementing a seperate process for training and ",tags$br(),
            "deploying the model on refreshed datasets", tags$br(),tags$br(),
           



           tags$br(),tags$br(),tags$h4("Author"),
           "John Mataya, Data Science",tags$br(),
           tags$br(),tags$br(),tags$h4("Contact"),
           "johnmataya@gmail.com",tags$br(), 

           absolutePanel(id = "logo", class = "card", bottom = 20, left = 20, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
                       tags$a(href='https://www.lockheedmartin.com/en-us/index.html', tags$img(src='B-logo.png',height='90',width='250')))
           
  ),
  
  
  selected = "Staffing Demand"
  ) #end  navbarPage function 

  
)