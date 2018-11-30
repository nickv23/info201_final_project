library(shiny)

college_data <- read.csv("MERGED2016_17_PP.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
   
  

  
  output$distPlot <- renderPlot({
    
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
