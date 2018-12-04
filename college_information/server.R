library(shiny)
library(ggplot2)
library(scales)
library(dplyr)
library(leaflet)

college_data <- read.csv("MERGED2016_17_PP.csv", stringsAsFactors = FALSE)
collegeInfo <- read.csv("state_info.csv", stringsAsFactors = FALSE)


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
  StateInput <- reactive({      # captures the state the user chose
    paste(input$States)
  })
  
  output$ChosenState <- renderUI ({
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC, OPEID)
    
    trim_stateInfo <- college_data %>%
      select(OPEID, STABBR)
    
    joinTables <- left_join(trim_raceInfo, trim_stateInfo, by="OPEID")
    state_data <- joinTables %>%
      select(INSTNM, STABBR) %>%
      filter(STABBR == StateInput())
    selectInput("Colleges", "Choose a College", choices = c(state_data$INSTNM))
  })
  
  output$RaceInfo <- renderTable({    # Renders a table of the DATA
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC)  %>%
      rowwise() %>%
      mutate(PCT_WHITE = if((PCT_WHITE == 'NULL')) "0" else PCT_WHITE) %>%
      mutate(PCT_BLACK = if((PCT_BLACK == 'NULL')) "0" else PCT_BLACK) %>%
      mutate(PCT_ASIAN = if((PCT_ASIAN == 'NULL')) "0" else PCT_ASIAN) %>%
      mutate(PCT_HISPANIC = if((PCT_HISPANIC == 'NULL')) "0" else PCT_HISPANIC)
    
    trim_raceInfo$PCT_WHITE = paste0(round(as.numeric(trim_raceInfo$PCT_WHITE), digits = 1), '%')
    trim_raceInfo$PCT_BLACK = paste0(round(as.numeric(trim_raceInfo$PCT_BLACK), digits = 1), '%')
    trim_raceInfo$PCT_ASIAN = paste0(round(as.numeric(trim_raceInfo$PCT_ASIAN), digits = 1), '%')
    trim_raceInfo$PCT_HISPANIC = paste0(round(as.numeric(trim_raceInfo$PCT_HISPANIC), digits = 1), '%')
    
    rename <- trim_raceInfo %>%
      mutate(College = INSTNM, White = PCT_WHITE, Black = PCT_BLACK, 
             Asian = PCT_ASIAN, Hispanic = PCT_HISPANIC) %>%
      select(College,White,Black,Asian,Hispanic) %>%
      filter(College == input$Colleges)
  })
  
  output$distPlot <- renderPlot ({     # Renders a Pie Chart 
    trim_raceInfo <- collegeInfo %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC, OPEID)
    
    trim_stateInfo <- college_data %>%
      select(OPEID, STABBR)
    
    joinTables <- left_join(trim_raceInfo, trim_stateInfo, by="OPEID")
    
    college_data <- joinTables %>%
      select(INSTNM, PCT_WHITE, PCT_BLACK, PCT_ASIAN, PCT_HISPANIC) %>%
      filter(INSTNM == input$Colleges)
    
    data_frame <- data.frame(
      Races = c("White", "Black", "Asian", "Hispanic"),
      value = round(as.numeric(c(college_data$PCT_WHITE, college_data$PCT_BLACK, college_data$PCT_ASIAN, college_data$PCT_HISPANIC)),
                    digits = 1)
    )
    p <- ggplot(data_frame, aes(x="", y=value, fill=Races)) +
      geom_bar(width=1, stat="identity", color="black") +
      coord_polar(theta ="y", start = 0) +
      theme_void() +
      ggtitle(paste0("Race Percentages at ", input$Colleges)) +
      scale_fill_brewer(palette = "Pastel2") +
      theme(plot.title = element_text(size=20)) +
      theme(text= element_text(size=15)) +   # changes size of legend text
      geom_text(size=6,aes(label = paste0(value,'%')), position=position_stack(vjust=0.5), angle=45)
    p + guides(fill =
                 guide_legend (
                   title.theme = element_text(size = 20,face="plain", colour ="black", angle=0)  # changes the size of legend title
                 )
    )
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
      mutate(ACTCMMID = if(ACTCMMID == "NULL") "No Scores" else ACTCMMID) %>% 
      mutate(ACTENMID = if(ACTENMID == "NULL") "No Scores" else ACTENMID) %>% 
      mutate(ACTMTMID = if(ACTMTMID == "NULL") "No Scores" else ACTMTMID) %>% 
      mutate(ACTWRMID = if(ACTWRMID == "NULL") "No Scores" else ACTWRMID)
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
    score_ACT_actual_score <- c(scores_school_ACT$ACTCMMID, scores_school_ACT$ACTENMID, 
                                scores_school_ACT$ACTMTMID, scores_school_ACT$ACTWRMID)
    score_graph_data <- data.frame("TypeACT" = score_ACT_Type, "ACTScore" = score_ACT_actual_score)
    
    # Making the color scheme for the bar graph
    score_colors <- c("#CC0000", "#3333CC", "#99CCFF", "#00CCFF")
    #***************************************************************************************************
    # Making my titles for the graph
    score_title <- paste0("ACT scores for ", ACT_school)
    legend_title <- "ACT Score Type"
    #***************************************************************************************************
    # Make plot
    ggplot(score_graph_data, aes(x=TypeACT, y=ACTScore, fill=TypeACT)) +
      geom_bar(stat="identity") +
      scale_fill_manual(legend_title, values=score_colors) +
      theme(plot.title = element_text(color="black", size=14, face="bold"),
            axis.title.x = element_text(color="black", size=12, face="bold"),
            axis.title.y = element_text(color="black", size=12, face="bold"),
            legend.title = element_text(color="black", size=10, face="bold")
      )  +
      labs(
        title = score_title,
        x="Type of ACT Score",
        y="ACT Score"
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
      mutate(SAT_AVG = if(SAT_AVG == "NULL") "No Scores" else SAT_AVG) %>% 
      mutate(SATMTMID = if(SATMTMID == "NULL") "No Scores" else SATMTMID) %>% 
      mutate(SATVRMID = if(SATVRMID == "NULL") "No Scores" else SATVRMID) %>% 
      mutate(SATWRMID = if(SATWRMID == "NULL") "No Scores" else SATWRMID)
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
    score_SAT_actual_score <- c(scores_school_SAT$SAT_AVG, scores_school_SAT$SATMTMID, 
                                scores_school_SAT$SATVRMID, scores_school_SAT$SATWRMID)
    score_graph_data_SAT <- data.frame("TypeSAT" = score_SAT_Type, "SATScore" = score_SAT_actual_score)
    
    # Making the color scheme for the bar graph
    score_colors_SAT <- c("#FF0099", "#669900", "#66FF99", "#00CC99")
    #***************************************************************************************************
    # Making my titles for the graph
    score_title_SAT <- paste0("SAT scores for ", SAT_school)
    legend_title_SAT <- "SAT Score Type"
    #***************************************************************************************************
    # Make plot
    ggplot(score_graph_data_SAT, aes(x=TypeSAT, y=SATScore, fill=TypeSAT)) +
      geom_bar(stat="identity") +
      scale_fill_manual(legend_title_SAT, values=score_colors_SAT) +
      theme(plot.title = element_text(color="black", size=14, face="bold"),
            axis.title.x = element_text(color="black", size=12, face="bold"),
            axis.title.y = element_text(color="black", size=12, face="bold"),
            legend.title = element_text(color="black", size=10, face="bold")
      )  +
      labs(
        title = score_title_SAT,
        x="Type of SAT Score",
        y="Midpoint SAT Score"
      )
    #***************************************************************************************************
  })
  # ======================================================
  
  
  
  # =========== Paste your code after the text ===========
  # Steffany!!!
  # ======================================================

})

