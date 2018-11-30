library(shiny)
library(ggplot2)
library(scales)
library(dplyr)
library(leaflet)

college_data <- read.csv("MERGED2016_17_PP.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
   
  # =========== Paste your code after the text ===========
  # Nick!!!!!!
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
