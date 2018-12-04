library(shiny)
library(ggplot2)
library(scales)
library(dplyr)
library(leaflet)

college_data <- read.csv("MERGED2016_17_PP.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  
  # =========== Paste your code after the text ===========
  # Nick!!!!!!
  leaflet_data <- college_data %>% select(INSTNM, STABBR, LATITUDE, LONGITUDE) 
  
  output$map_state_select <- renderUI({
    selectInput("map_state_select", label = h3("Select a State"), 
                choices = c("No States" = "NS", "All States" = "US", "Alabama" = "AL", "Alaska" = "AK", "Arizona" = "AZ",
                            "Arkansas" = "AR", "California" = "CA", "Colorado" = "CO", "Connecticut" = "CT",
                            "Delaware" = "DE", "Florida" = "FL", "Georgia" = "GA", "Hawaii" = "HI",
                            "Idaho" = "ID", "Illinois" = "IL", "Indiana" = "IN", "Iowa" = "IA",
                            "Kansas" = "KS", "Kentucky" = "KY", "Louisiana" = "LY", "Maine" = "ME",
                            "Maryland" = "MD", "Massachusetts" = "MA", "Michigan" = "MI", "Minnesota" = "MN",
                            "Mississippi" = "MS", "Missouri" = "MO", "Montana" = "MT", "Nebraska" = "NE",
                            "Nevada" = "NV", "New Hampshire" = "NH", "New Jersey" = "NJ", "New Mexico" = "NM",
                            "New York" = "NY", "North Carolina" = "NC", "North Dakota" = "ND", "Ohio" = "OH",
                            "Oklahoma" = "OK", "Oregon" = "OR", "Pennsylvania" = "PA", "Rhode Island" = "RI",
                            "South Carolina" = "SC", "South Dakota" = "SD", "Tennessee" = "TN", "Texas" = "TX",
                            "Utah" = "UT", "Vermont" = "VT", "Virginia" = "VA", "Washington" = "WA",
                            "West Virginia" = "WV", "Wisconsin" = "WI", "Wyoming" = "WY"), 
                selected = "NS")
  })
  
  output$map_plot <- renderLeaflet({
    if (input$map_state_select == "US") {
      state_data <- leaflet_data  
    } else {
      state_data <- leaflet_data %>% filter(STABBR == input$map_state_select)  
    }
    #state_data <- leaflet_data %>% filter(STABBR == input$map_state_select)
    if(nrow(state_data) == 0) {
      map_markers <- leaflet(state_data) %>% addTiles()  
    } else {
      map_markers <- leaflet(state_data) %>% addTiles() %>% 
        addMarkers(lng = as.numeric(state_data$LONGITUDE), lat = as.numeric(state_data$LATITUDE), label = state_data$INSTNM)
    }
    map_markers
  })
  
  # ======================================================
  
  
  
  # =========== Paste your code after the text ===========
  # Linley!!!
  # ======================================================
  
  
  # =========== Paste your code after the text ===========
  # Lia!!!
  # ======================================================
  
  
  
  # =========== Paste your code after the text ===========
  # Steffany!!!
  # ======================================================
  
  output$distPlot <- renderPlot({
    
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})