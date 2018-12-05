library(shiny)
library(leaflet)
library(shinythemes)
library(plotly)
library(kableExtra)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),

  navbarPage(
    title = "College Information",

    tabPanel(
      "About",
      h2("About Our Final Project"),
      h4("Members: Lia Johansen, Steffany Ng, Linley Porter,  Nick Verghese"),
      h2("College Statistics", align="center"),
      div(img(src="college.jpeg", width=900), style="text-align: center"),
      br(),
      br(),
      h3("Our Data:"),
      p("Our data came from ", a(href = "https://collegescorecard.ed.gov/data/", "College Scorecard Data"), ". 
        The data shows information from 2016-2017."),
      h3("Our Audience:"),
      p("Our target audience are high school students and college students who are in the process of 
        finding colleges they want to apply to and attend. They will want to know basic information 
        about each college such as location, diversity, ACT/SAT scores, admission acceptance rates, and tuition costs."),
      h3("Our Widgets:"),
      p(strong("Location: "), "The locations tab allows you locate all the available colleges within a selected state.
        Hover your mouse over a marker to get the full name of the college."),
      p(strong("Diversity: "), "The diversity tab allows you to look at race data for colleges. Simply choose a state
        that you're interested in and then choose a college within that state. A pie chart should show up 
        that gives the percentages of each race. You can hover over the pie chart slices and see the exact percentages
        if it is hard to read. A table also renders giving the same data on race percentages to allow the user to see
        the data in a graph and table view."),
      p(strong("Score: "), "The score tab allows students to look at the median/middle scores (both ACT and SAT) for 
        a particular school. Choose a state and then choose a college/university that is in that state from the drop down menu. 
        A bar graph will show the midpoint ACT and another bar graph will show the midpoint SAT scores. 
        For the ACT this includes midpoint of cumulative, english, math, and writing scores. For the SAT this 
        includes average, math, reading, and writing scores."),
      p(strong("Admission Statistics: "), "The admissions tab allows students to look at their selected
        colleges' admission rates and compare them to one another. Furthermore, students can also look
        at a table of information with the name, city, state, instate tuition, outstate tuition, and 
        the college's website.")
    ),


    # =========== Locations ===========

    tabPanel(
      "Locations", 
      p("In this tab, you can view all the availabe colleges for a selected state. To see the name of a specific college,
        hover the cursor over its marker."),
      sidebarLayout(
        sidebarPanel(
          
          uiOutput("map_state_select")
          
        ),
        
        mainPanel(
          leafletOutput("map_plot")
        )
      )
    ),
    # =========== Diversity ===========

    tabPanel(

      "Diversity", 
      sidebarLayout(
        sidebarPanel(
          selectInput("States",
                      # Select a particular State
                      label = h3("Select a State"),
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
                                     "Wisconsin"="WI","Wyoming"="WY"),
                      selected = "AL"),
          uiOutput("ChosenState"),
          tableOutput("RaceInfo")
        ),
        
        mainPanel(
          p("The pie chart rendered shows the statistics for four races: white, black, hispanic, and asian.
             Once the user chooses a state and then a college within the state the pie chart should
             render a new chart that represents data for that specific college"),
          
          br(),
          # Plots pie chart of race percentages
          plotlyOutput("plot", height = "100%")
        )
      )
 
    ),
    # =========== Scores ===========

    tabPanel(
      "Scores", # Title

      sidebarLayout(
        sidebarPanel(
          # Select a particular state
          selectInput("State",
            label = h3("Select a State"),
            choices = list(
              "Alabama" = "AL", "Alaska" = "AK", "Arizona" = "AZ", "Arkansas" = "AR",
              "California" = "CA", "Colorado" = "CO", "Connecticut" = "CT", "Delaware" = "DE",
              "Florida" = "FL", "Georgia" = "GA", "Hawaii" = "HI", "Idaho" = "ID", "Illinois" = "IL",
              "Indiana" = "IN", "Iowa" = "IA", "Kansas" = "KS", "Kentucky" = "KY", "Louisiana" = "LA",
              "Maine" = "ME", "Maryland" = "MD", "Massachusetts" = "MA", "Michigan" = "MI", "Minnesota" = "MN",
              "Mississippi" = "MS", "Missouri" = "MO", "Montana" = "MT", "Nebraska" = "NE", "Nevada" = "NV",
              "New Hampshire" = "NH", "New Jersey" = "NJ", "New Mexico" = "NM", "New York" = "NY", "North Carolina" = "NC",
              "North Dakota" = "ND", "Ohio" = "OH", "Oklahoma" = "OK", "Oregon" = "OR", "Pennsylvania" = "PA",
              "Rhode Island" = "RI", "South Carolina" = "SC", "South Dakota" = "SD", "Tennessee" = "TN",
              "Texas" = "TX", "Utah" = "UT", "Vermont" = "VT", "Virginia" = "VA", "Washington" = "WA", "West Virginia" = "WV",
              "Wisconsin" = "WI", "Wyoming" = "WY"
            ), selected = "AL"
          ),

          # Select a particular school in the chosen state
          uiOutput("schoolName")
        ),


        mainPanel(
          
          p("The first barplot shows the midpoint ACT scores for cumulative, english, math, and writing. 
            The second barplot shows the average SAT scores for average, math, reading and writing"),
          
          br(),
          
          # plotting ACT bar graph
          plotOutput("ACTPlot"),
          
          # Get rid of the error messages (graphs still work)
          tags$style(
            type = "text/css",
            ".shiny-output-error { visibility: hidden; }",
            ".shiny-output-error:before { visibility: hidden; }"
          ),

          # plotting SAT bar graph
          plotOutput("SATPlot")
        )
      )
    ),
    # =========== Admission Statistics ===========

    tabPanel(
      "Admission Statistics",
      sidebarLayout(
        sidebarPanel(
          uiOutput("admiss_states"),
          uiOutput("admiss_school")
        ),
        mainPanel(
          p("The barplot below shows the admission rates of the school you select. 
            You can select as many schools as you want but it's recommeded to not choose more than 10
            for a good visualization.
            You can also get the information from the schools selected."),
          tabsetPanel(
            tabPanel(
              "Rates",
              plotOutput("admiss_plot", height = "100%")
            ),
            tabPanel(
              "Schools' Info",
              tableOutput("table")
            )
          )
        )
      )
    )
  )
))
