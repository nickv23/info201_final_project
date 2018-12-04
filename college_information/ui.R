library(shiny)
library(leaflet)

shinyUI(fluidPage(

  # We can remove the separators after we are done
  # Plots don't show if you run the app rn 
  # because it's the same code & plot for each tab
  # so don't panic! (just letting you know if you wonder why)
  
  navbarPage(
    title = "College Information",
    tabPanel(
      "About",
      h2("About Our Final Project"),
      h4("Members: Lia Johansen, Steffany Ng, Linley Porter,  Nick Verghese"),
      img(src="college.jpeg"),
      br(),
      h3("Our Data:"),
      p("Our data came from ", a(href="https://collegescorecard.ed.gov/data/", "College Scorecard Data")),
      h3("Our Audience:"), 
      p("Our target audience are high school students and college students who are in the process of 
        finding colleges they want to apply to and attend. They will want to know basic information 
        about each college such as location, diversity, ACT/SAT scores, admission acceptance rates, and tuition costs."),
      h3("Our Widgets:"), 
      p(strong("Location: "), "Choose a state from the drop down menu and the map will show you the locations 
        of all of the colleges in that chosen state"),
      p(strong("Population: "), "Linley INSERT TEXT HERE"),
      p(strong("Score: "), "Choose a state and then choose a college/university that is in that state from the drop down menu. 
        Then a bar graph will show the midpoint ACT and another bar graph will show the midpoint SAT scores. 
        For the ACT this includes midpoint of cumulative, english, math, and writing scores. For the SAT this is 
        includes average, math, reading, and writing scores."),
      p(strong("Admission Statistics: "), "STEFFANY INERST")
      
    ),

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
      "You can change the text here to whatever you need"

      # This is just an example, delete this and put your code here with your code.

    ),
    # =========== Paste your code after the text ===========

    tabPanel(
      "Scores", # Title
      
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
                                     "Wisconsin"="WI","Wyoming"="WY"), selected = "AL"),
          
          # Select a particular school in the chosen state
          uiOutput("schoolName")
        ),
        
        

        mainPanel(
          # plotting ACT bar graph
          plotOutput("ACTPlot"),
          
          tags$style(type="text/css",
                     ".shiny-output-error { visibility: hidden; }",
                     ".shiny-output-error:before { visibility: hidden; }"
          ),
          
          #plotting SAT bar graph
          plotOutput("SATPlot")
        )
      )
    ),
    # =========== Paste your code after the text ===========

    tabPanel(
      "Admission Statistics",
      "You can change the text here to whatever you need"
    )
    # ======================================================
  )
))
