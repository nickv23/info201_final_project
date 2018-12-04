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
      "Here, you can see the select your state of interest and see all colleges within it. Hover over the marker to
        see the name of the college.",
      
      # This is just an example, delete this and put your code here with your code.
      sidebarLayout(
        sidebarPanel(
          uiOutput("map_state_select")
        ),
        mainPanel(
          leafletOutput("map_plot")
          #, leaflet() %>% addTiles()
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
      "LIA THIS IS YOURS",
      # This is just an example, delete this and put your code here with your code.
      sidebarLayout(
        sidebarPanel(
          # Select a particular state
          selectInput("State", label = h3("Select a State"), 
                      choices = list("Alabama"="AL", "Alaska"="AK", "Arizona"="AZ", "Arkansas"="AR",
                                     "California"="CA", "Colorado"="CO", "Connecticut"="CT", "Delaware"="DE",
                                     "Florida"="FL", "Georgia"="GA", "Hawaii"="HI", "Idaho"="ID", "Illinois"="IL",
                                     "Indiana"="IN", "Iowa"="IA", "Kansas"="KS", "Kentucky"="KY", "Louisiana"="LA",
                                     "Maine"="ME", "Maryland"="MD", "Massachusetts"="MA", "Michigan"="MI", "Minnesota"="MN",
                                     "Mississippi"="MS", "Missouri"="MO", "Montana"="MT", "Nebraska"="NE", "Nevada"="NV",
                                     "New Hampshire"="NH", "New Jersey"="NJ", "New Mexico"="NM", "New York"="NY", "North Carolina"= "NC",
                                     "North Dakota"="ND", "Ohio"="OH", "Oklahoma"="OK", "Oregon"="OR", "Pennsylvania"="PA",
                                     "Rhode Island"="RI", "South Carolina"="SC", "South Dakota"="SD", "Tennessee"="TN",
                                     "Texas"="TX", "Utah"="UT", "Vermont"="VT", "Virginia"="VA", "Washington"="WA", "West Virginia"="WV",
                                     "Wisconsin"="WI","Wyoming"="WY"), selected = "AL")
        ),
        
        mainPanel(
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
