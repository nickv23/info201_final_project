library(shiny)
library(ggplot2)
library(scales)
library(dplyr)
library(leaflet)
library(plotly)


college_data <- read.csv("college_data.csv", stringsAsFactors = FALSE)
collegeInfo <- read.csv("state_info.csv", stringsAsFactors = FALSE)


shinyServer(function(input, output) {
  output$image <- renderImage({
    list(
      src = "college.jpeg",
      width = 750,
      height = 464
    )
  }, deleteFile = FALSE)

  # =========== Paste your code after the text ===========
  # Nick!!!!!!
  leaflet_data <- college_data %>% select(INSTNM, STABBR, LATITUDE, LONGITUDE)

  output$map_state_select <- renderUI({
    selectInput("map_state_select",
      label = h3("Select a State"),
      choices = c(
        "No States" = "NS", "All States" = "US", "Alabama" = "AL", "Alaska" = "AK", "Arizona" = "AZ",
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
        "West Virginia" = "WV", "Wisconsin" = "WI", "Wyoming" = "WY"
      ),
      selected = "NS"
    )
  })

  output$map_plot <- renderLeaflet({
    if (input$map_state_select == "US") {
      state_data <- leaflet_data
    } else {
      state_data <- leaflet_data %>% filter(STABBR == input$map_state_select)
    }
    if (nrow(state_data) == 0) {
      map_markers <- leaflet(state_data) %>% addTiles()
    } else {
      map_markers <- leaflet(state_data) %>%
        addTiles() %>%
        addMarkers(lng = as.numeric(state_data$LONGITUDE), lat = as.numeric(state_data$LATITUDE), label = state_data$INSTNM)
    }
    map_markers
  })

  # ======================================================



  # =========== Paste your code after the text ===========
  # Linley!!!
  StateInput <- reactive({ # captures the state the user chose
    paste(input$States)
  })

  output$ChosenState <- renderUI({  # Gives choice of College depending on users input
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC, OPEID)

    trim_stateInfo <- college_data %>%
      select(OPEID, STABBR)

    joinTables <- left_join(trim_raceInfo, trim_stateInfo, by = "OPEID")
    state_data <- joinTables %>%
      select(INSTNM, STABBR) %>%
      filter(STABBR == StateInput())
    selectInput("Colleges", label = h3("Select a School"), choices = c(state_data$INSTNM))
  })

  output$RaceInfo <- renderTable({ # Renders a table of the DATA
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC) %>%
      rowwise() %>%
      mutate(PCT_WHITE = if ((PCT_WHITE == "NULL")) "0" else PCT_WHITE) %>%
      mutate(PCT_BLACK = if ((PCT_BLACK == "NULL")) "0" else PCT_BLACK) %>%
      mutate(PCT_ASIAN = if ((PCT_ASIAN == "NULL")) "0" else PCT_ASIAN) %>%
      mutate(PCT_HISPANIC = if ((PCT_HISPANIC == "NULL")) "0" else PCT_HISPANIC)

    trim_raceInfo$PCT_WHITE <- paste0(round(as.numeric(trim_raceInfo$PCT_WHITE), digits = 1), "%")
    trim_raceInfo$PCT_BLACK <- paste0(round(as.numeric(trim_raceInfo$PCT_BLACK), digits = 1), "%")
    trim_raceInfo$PCT_ASIAN <- paste0(round(as.numeric(trim_raceInfo$PCT_ASIAN), digits = 1), "%")
    trim_raceInfo$PCT_HISPANIC <- paste0(round(as.numeric(trim_raceInfo$PCT_HISPANIC), digits = 1), "%")

    rename <- trim_raceInfo %>%
      mutate(College = INSTNM, White = PCT_WHITE, Black = PCT_BLACK,
            Asian = PCT_ASIAN, Hispanic = PCT_HISPANIC) %>%
      select(College, White, Black, Asian, Hispanic) %>%
      filter(College == input$Colleges)
  })

  output$plot <- renderPlotly({    # Renders a Pie Chart
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC, OPEID)

    trim_stateInfo <- college_data %>%
      select(OPEID, STABBR)

    joinTables <- left_join(trim_raceInfo, trim_stateInfo, by = "OPEID")

    college_data <- joinTables %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC) %>%
      filter(INSTNM == input$Colleges)

    data_frame <- data.frame(
      Races = c("White", "Black", "Asian", "Hispanic"),
      value = round(as.numeric(c(college_data$PCT_WHITE, college_data$PCT_BLACK, college_data$PCT_ASIAN, college_data$PCT_HISPANIC)),
        digits = 1
      )
    )
    
    colors <- c('rgb((240,128,128))', '	rgb(216,191,216)', 'rgb(255,235,205)', 'rgb(240,248,255)', 'rgb(114,147,203)')
    plot_ly(data_frame, labels=~Races, values=~value, type='pie',
            textposition = 'inside',
            textinfo = 'label+percent',
            insidetextfont = list(color = '#000000'),
            marker = list(colors=colors, line = list(color='#FFFFFF'), width=5)) %>%
      layout(title = paste0("Race Percentages at ", input$Colleges), 
             xaxis = list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE),
             yaxis = list(showgrid=FALSE, zeroline=FALSE, showticklabels=FALSE))
  })
  # ======================================================


  # =========== Paste your code after the text ===========
  # Lia!!!
  output$schoolName <- renderUI({
    state_school_list <- college_data %>%
      filter(STABBR == input$State) %>%
      select(INSTNM) %>%
      arrange(INSTNM) %>%
      rename("University" = INSTNM)

    selectInput("School", label = h3("Select a School"), state_school_list)
  })


  output$ACTPlot <- renderPlot({
    #***************************************************************************************************
    # Get only the ACT scores for a certain state
    # Use this for all of the ACT plots
    state <- input$State
    scores_ACT <- college_data %>%
      filter(STABBR == state) %>%
      select(INSTNM, CITY, STABBR, ACTCMMID, ACTENMID, ACTMTMID, ACTWRMID) %>%
      rowwise() %>%
      mutate(ACTCMMID = if (ACTCMMID == "NULL") "No Scores" else ACTCMMID) %>%
      mutate(ACTENMID = if (ACTENMID == "NULL") "No Scores" else ACTENMID) %>%
      mutate(ACTMTMID = if (ACTMTMID == "NULL") "No Scores" else ACTMTMID) %>%
      mutate(ACTWRMID = if (ACTWRMID == "NULL") "No Scores" else ACTWRMID)
    #***************************************************************************************************
    # List of the schools in given state
    score_school_list <- scores_ACT$INSTNM
    # Get particular school
    ACT_school <- input$School

    # Getting the particular school
    scores_school_ACT <- scores_ACT %>%
      filter(INSTNM == ACT_school)
    #***************************************************************************************************
    # Making my new data frame which contains the
    # type of act score and the score
    score_ACT_Type <- c("Cumulative", "English", "Math", "Writing")
    score_ACT_actual_score <- c(
      scores_school_ACT$ACTCMMID, scores_school_ACT$ACTENMID,
      scores_school_ACT$ACTMTMID, scores_school_ACT$ACTWRMID
    )
    score_graph_data <- data.frame("TypeACT" = score_ACT_Type, "ACTScore" = score_ACT_actual_score)

    # Making the color scheme for the bar graph
    score_colors <- c("#CC0000", "#3333CC", "#99CCFF", "#00CCFF")
    #***************************************************************************************************
    # Making my titles for the graph
    score_title <- paste0("ACT scores for ", ACT_school)
    legend_title <- "ACT Score Type"
    #***************************************************************************************************
    # Make plot
    ggplot(score_graph_data, aes(x = TypeACT, y = ACTScore, fill = TypeACT)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(legend_title, values = score_colors) +
      theme(
        plot.title = element_text(color = "black", size = 14, face = "bold"),
        axis.title.x = element_text(color = "black", size = 12, face = "bold"),
        axis.title.y = element_text(color = "black", size = 12, face = "bold"),
        legend.title = element_text(color = "black", size = 10, face = "bold")
      ) +
      labs(
        title = score_title,
        x = "Type of ACT Score",
        y = "ACT Score"
      )
  })

  output$SATPlot <- renderPlot({
    #***************************************************************************************************
    req(input$State)
    # Filter out only the data from that particular state
    # and the SAT Scores (midpoints)
    scores_SAT <- college_data %>%
      filter(STABBR == input$State) %>%
      select(INSTNM, CITY, STABBR, SAT_AVG, SATMTMID, SATVRMID, SATWRMID) %>%
      rowwise() %>%
      mutate(SAT_AVG = if (SAT_AVG == "NULL") "No Scores" else SAT_AVG) %>%
      mutate(SATMTMID = if (SATMTMID == "NULL") "No Scores" else SATMTMID) %>%
      mutate(SATVRMID = if (SATVRMID == "NULL") "No Scores" else SATVRMID) %>%
      mutate(SATWRMID = if (SATWRMID == "NULL") "No Scores" else SATWRMID)
    #***************************************************************************************************
    # List of the schools in given state
    change_score_school_list <- scores_SAT$INSTNM
    # Get particular school
    SAT_school <- input$School

    # Getting the particular school
    scores_school_SAT <- scores_SAT %>%
      filter(INSTNM == SAT_school)
    #***************************************************************************************************
    # Making my new data frame which contains the
    # type of act score and the score
    score_SAT_Type <- c("Average", "Math", "Reading", "Writing")
    score_SAT_actual_score <- c(
      scores_school_SAT$SAT_AVG, scores_school_SAT$SATMTMID,
      scores_school_SAT$SATVRMID, scores_school_SAT$SATWRMID
    )
    score_graph_data_SAT <- data.frame("TypeSAT" = score_SAT_Type, "SATScore" = score_SAT_actual_score)

    # Making the color scheme for the bar graph
    score_colors_SAT <- c("#FF0099", "#669900", "#66FF99", "#00CC99")
    #***************************************************************************************************
    # Making my titles for the graph
    score_title_SAT <- paste0("SAT scores for ", SAT_school)
    legend_title_SAT <- "SAT Score Type"
    #***************************************************************************************************
    # Make plot
    ggplot(score_graph_data_SAT, aes(x = TypeSAT, y = SATScore, fill = TypeSAT)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(legend_title_SAT, values = score_colors_SAT) +
      theme(
        plot.title = element_text(color = "black", size = 14, face = "bold"),
        axis.title.x = element_text(color = "black", size = 12, face = "bold"),
        axis.title.y = element_text(color = "black", size = 12, face = "bold"),
        legend.title = element_text(color = "black", size = 10, face = "bold")
      ) +
      labs(
        title = score_title_SAT,
        x = "Type of SAT Score",
        y = "Midpoint SAT Score"
      )
    #***************************************************************************************************
  })
  # ======================================================


  # =========== Paste your code after the text ===========
  # Steffany!!!

  # Reads data and selects necessary columns
  admiss_data <- reactive({
    filtered_data <- college_data %>%
      select(INSTNM, CITY, STABBR, INSTURL, ADM_RATE, TUITIONFEE_IN, TUITIONFEE_OUT)
  })

  # State selection
  output$admiss_states <- renderUI({
    selectInput("states",
      label = h3("Select a State:"),
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
      ),
      selected = "AL"
    )
  })

  # Filters data from iser input
  admiss_filtered_data <- reactive({
    data <- admiss_data()
    req(input$states)
    admiss_filtered <- data %>%
      filter(STABBR == input$states) %>%
      mutate(ADM_RATE = replace(ADM_RATE, ADM_RATE == "NULL", 0)) %>%
      mutate(ADM_RATE = as.numeric(ADM_RATE) * 100)
  })

  # Colleges selection for comparison
  output$admiss_school <- renderUI({
    data <- admiss_filtered_data()
    selectInput("school",
      label = h5("Select colleges to compare:"),
      choices = data$INSTNM,
      multiple = TRUE
    )
  })

  # Makes barplot from user selected colleges
  output$admiss_plot <- renderPlot({
    filtered_data <- admiss_filtered_data()
    schools <- input$school
    data <- filtered_data[filtered_data$INSTNM %in% schools, ] %>% mutate(Group = ifelse(ADM_RATE > 0, "B", "R"))
    plot <- ggplot() +
      geom_bar(
        data = data,
        aes(x = INSTNM, y = ADM_RATE, fill = Group, colour = Group),
        stat = "identity",
        width = 0.8
      ) +
      scale_colour_manual(values = c("B" = "cyan3", "R" = "red2")) +
      scale_fill_manual(
        values = c("B" = "cyan3", "R" = "red2"),
        label = c("B" = "Available", "R" = "Not available")
      ) +
      scale_y_continuous(breaks = seq(0, 100, by = 20)) +
      guides(color = FALSE, fill = guide_legend(title = "Rate Availability")) +
      expand_limits(y = c(0, 100)) +
      labs(
        x = "Institutions",
        y = "Admission Rate (%)",
        title = paste("Admission rates from", input$states)
      ) +
      theme(
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        plot.title = element_text(color = "Black", size = rel(1.7), face = "bold", hjust = 0),
        axis.title.y = element_text(size = rel(1.2)),
        axis.title.x = element_text(size = rel(1.2)),
        legend.position = "bottom",
        legend.title = element_text(size = rel(1.1), face = "bold"),
        legend.text = element_text(size = rel(1)),
        panel.background = element_rect(fill = "gray96"),
        panel.grid.major.x = element_blank()
      )
    plot
  }, height = 650)

  # Makes a information table from user selected colleges
  output$table <- function() {
    data <- admiss_filtered_data()
    schools <- input$school
    data <- filtered_data[filtered_data$INSTNM %in% schools, ]
    table_data <- data %>%
      select(INSTNM, CITY, STABBR, TUITIONFEE_IN, TUITIONFEE_OUT, INSTURL) %>%
      mutate(
        TUITIONFEE_IN = replace(TUITIONFEE_IN, TUITIONFEE_IN == "NULL", "-"),
        TUITIONFEE_OUT = replace(TUITIONFEE_OUT, TUITIONFEE_OUT == "NULL", "-")
      ) %>%
      rename(
        Institution = INSTNM, City = CITY, State = STABBR,
        "Instate Tuition" = TUITIONFEE_IN,
        "Outstate Tuition" = TUITIONFEE_OUT, Website = INSTURL
      ) %>%
      mutate(Website = text_spec(Website, link = Website)) %>%
      knitr::kable("html", escape = FALSE) %>%
      kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
  }
  # ======================================================
})
