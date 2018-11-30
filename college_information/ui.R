library(shiny)
library(leaflet)

shinyUI(fluidPage(

  # We can remove the separators after we are done
  # Plots don't show if you run the app rn 
  # because it's the same code & plot for each tab
  # so don't panic! (just letting you know if you wonder why)
  
  navbarPage(
    title = "College Information",
    tabPanel("About", "This is the about page."),

    # =========== Paste your code after the text ===========

    tabPanel(
      "Locations", # feel free to change the title!
      "You can change the text here to whatever you need",

      # This is just an example, delete this and put your code here with your code.
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins",
            "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          )
        ),

        mainPanel(
          plotOutput("distPlot")
        )
      )
    ),
    # =========== Paste your code after the text ===========

    tabPanel(
      "Population", # feel free to change the title!
      "You can change the text here to whatever you need",

      # This is just an example, delete this and put your code here with your code.
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins",
            "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          )
        ),

        mainPanel(
          plotOutput("distPlot")
        )
      )
    ),
    # =========== Paste your code after the text ===========

    tabPanel(
      "Scores", # feel free to change the title!
      "You can change the text here to whatever you need",
      # This is just an example, delete this and put your code here with your code.
      sidebarLayout(
        sidebarPanel(
          sliderInput("bins",
            "Number of bins:",
            min = 1,
            max = 50,
            value = 30
          )
        ),

        mainPanel(
          plotOutput("distPlot")
        )
      )
    ),
    # =========== Paste your code after the text ===========

    tabPanel(
      "Admission Rates",
      "You can change the text here to whatever you need"
    )
    # ======================================================
  )
))
