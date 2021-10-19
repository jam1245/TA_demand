

# 1. PACKAGES -------------------------------------------------------------
source("library/library.R")

# 2. Data -------------------------------------------------------------
source("data/tidy_data.R")

# 3. Load Model -------------------------------------------------------------
my_model <- readRDS("model/my_rf_model.RDS")


# 3. Functions 
source("/mnt/shiny_functions/shiny_functions.R")


rf_model_v2 <- ranger(cycletime ~ 
                        city_simple + 
                        JOB_CATEGORY + 
                        JOB_CLASS +
                        sourcing +
                        hiring_mngr_review+
                        interview+
                        offer_pending+
                        offer_to_accept+ 
                        Clearance +
                        LEVEL, # formula 
                     sd_df, # data
                   num.trees =500, 
                   respect.unordered.factors = "order", 
                   mtry = 2,
                   min.node.size = 3,
                   sample.fraction = .8,
                   importance = "impurity",
                   seed = 2135)







# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
    
    
    #df %>% filter(city == input$city_name) # & median_cycletime.x >= input$range[1] & median_cycletime.x <= input$range[2])
    # Reactive expression for the data subsetted to what the user selected
    filteredData <- reactive({
      df[df$median_cycletime.x >= input$range[1] & df$median_cycletime.x <= input$range[2],]
    })
    
    # This reactive expression represents the palette function,
    # which changes as the user makes selections in UI.
    colorpal <- reactive({
      colorNumeric(input$colors, df$median_cycletime.x)
    })
    
    output$map <- renderLeaflet({
      # Use leaflet() here, and only include aspects of the map that
      # won't need to change dynamically (at least, not unless the
      # entire map is being torn down and recreated).
      
      data <- filteredData()
      
      binpal <- colorBin("Blues", data$median_cycletime.x, 6, pretty = FALSE)
      
      
      
      leaflet(data) %>% 
        
        #    addTiles() %>%
        #    addProviderTiles(providers$Stamen.Toner) %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        #     setView(39.02671271609735,-77.13495975135463, zoom = 10) %>% 
        fitBounds(-117, 24, -68.70975, 50.67552)  %>% 
        # fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat)) %>% 
        addCircles(radius = ~median_cycletime.x*800, weight = 1, color = "#fd903c",
                   stroke = TRUE, 
                  # fillColor = ~median_cycletime.x, 
                   fillColor = ~binpal(median_cycletime.x), #"#4a4d70",
                   fillOpacity = 0.5, popup = paste("City:", data$city, "<br>",
                                                    "State:", data$state, "<br>",
                                                    "Median Days of Cycle Time:", 
                                                    round(data$median_cycletime.x, digits = 1), "<br>" )
        )
      
      
    })
    
    # Incremental changes to the map (in this case, replacing the
    # circles when a new color is chosen) should be performed in
    # an observer. Each independent set of things that can change
    # should be managed in its own observer.
    observe({
      pal <- colorpal()
      
      data <- filteredData()
      
      leafletProxy("map", data = data) %>%
        clearShapes() %>%
        addCircles(radius = ~median_cycletime.x*800, weight = 1, color = "#fd903c",
                   fillColor = ~pal(median_cycletime.x), fillOpacity = 0.6, popup = paste("City:", data$city, "<br>",
                                                                                          "State:", data$state, "<br>",
                                                                                          "Median Days of Cycle Time:", round(data$median_cycletime.x, digits = 1), "<br>" )
        )
    })
    
    # Use a separate observer to recreate the legend as needed.
    observe({
      proxy <- leafletProxy("map", data = df)
      
      # Remove any existing legend, and only if the legend is
      # enabled, create a new one.
      proxy %>% clearControls()
      if (input$legend) {
        pal <- colorpal()
        proxy %>% 
      #    fitBounds(-117, 24, -68.70975, 50.67552) %>% 
          addLegend(position = "bottomright",
                            pal = pal, values = ~median_cycletime.x, title = "Cycle Time Range"
        )
      }
    })
    
    observeEvent(input$city_name, {
      
      pal <- colorpal()
      
      
      data <- filteredData() %>% filter(city_simple == input$city_name)
      
      leafletProxy("map") %>%
        clearShapes() %>%
        setView(lng=data$long, lat=data$lat, 5) %>%
#        addMarkers(data = df[df$city_simple == input$city_name, ],
#                   ~Longitude,
#                   ~Latitude,
#                   group = "myMarkers")
      
      #addCircles(data = data[data$city_simple == input$city_name, ],
      addCircles(data = data,
                 radius = ~median_cycletime.x*800, weight = 1, color = "#fd903c",
                 fillColor = ~pal(median_cycletime.x), fillOpacity = 0.6, popup = paste("City:", data$city, "<br>",
                                                                                        "State:", data$state, "<br>",
                                                                                        "Median Days of Cycle Time:", round(data$median_cycletime.x, digits = 1), "<br>" )
      )
    })
    

    observeEvent(input$map_marker_click, { # update the location selectInput on map clicks
      p <- input$map_marker_click
      if(!is.null(p$id)){
        if(is.null(input$city_name) || input$city_name!=p$id) updateSelectInput(session, "city_simple", selected=p$id)
      }
    })
    
    
    
    
    # leaflet Proxy - need to display the map in the navigation bar - second tab called staffing demand
 #     observe({
#        req(input$tab_being_displayed == "Staffing Demand") # Only display if tab is 'Staffing Demand'
#        leafletProxy("map", data = filteredData()) #%>%
#          clearShapes() %>%
#          addCircles(radius = ~median_cycletime.x, weight = 1, color = "#777777",
#                     fillColor = ~median_cycletime.x, fillOpacity = 0.7, popup = ~paste(median_cycletime.x)
#          )
    
#      })
    


    
    
    ###### staffing data 
    staffing_data = reactive(data.frame(JOB_CATEGORY = input$JOB_category_staffing,
                                            LEVEL = input$level_staffing,
                                  JOB_CLASS = input$JOB_class_staffing,
                                  city_simple=input$city_name, 
                                  sourcing = input$sourcing, 
                                  hiring_mngr_review = input$hiring_mngr_review, 
                                  interview = input$interview,
                                  offer_pending = input$offer_pending, 
                                  offer_to_accept = input$offer_to_accept,
                                  Clearance = input$Clearance_staffing))
    
    
    
    #### Map page numeric outputs 
    
    
    output$total_staffing_hours <- renderText({
      cycle_time_pred <- predict(rf_model_v2, staffing_data())$predictions
      
      staffing_var_low <- 0.125 # low 
      staff_hours_low <- round(input$Requistions*cycle_time_pred*staffing_var_low, digits = 1)
      
      staffing_var_high <- 0.16 # high 
      staff_hours_high <- round(input$Requistions*cycle_time_pred*staffing_var_high, digits = 1)
      
      paste(staff_hours_low, "-", staff_hours_high, " Total Recruiter Hours")
    #  paste0(prettyNum(round(staff_hours, digits = 1), big.mark=","), " Total Recruiter Hours")
    })
    
    output$recruiters_hours <- renderText({
      
      cycle_time_pred <- predict(rf_model_v2, staffing_data())$predictions
      
      staffing_var_low <- 0.125 # low 
      staff_hours_low <- input$Requistions*cycle_time_pred*staffing_var_low
      recruiters_low <- round(staff_hours_low/input$Recruiters, digits = 1)
      
      staffing_var_high <- 0.16 # high 
      staff_hours_high <- input$Requistions*cycle_time_pred*staffing_var_high
      recruiters_high <- round(staff_hours_high/input$Recruiters, digits = 1)
      
      paste(recruiters_low, "-", recruiters_high, " Hours per Recruiter")
    })
    
    
    output$cycletime_pred <- renderText({
      
      cycle_time_pred <- predict(rf_model_v2, staffing_data())$predictions
      
      paste0(prettyNum(round(cycle_time_pred, digits = 1), big.mark=","), " Cycle Time Prediction")
      
    })
    
}
)
    
    