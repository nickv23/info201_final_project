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
