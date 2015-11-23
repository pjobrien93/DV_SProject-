# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(reshape2)
require(shinydashboard)
require(leaflet)
require(DT)

shinyServer(function(input, output) {
    crimes <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select INSTNM , LIQUOR12, DRUG12, WEAPON12, MEN_TOTAL, TOTAL from RESIDENCEHALLARREST2013"'),
                                         httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_pjo293', PASS='orcl_pjo293', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  output$scatterPlot <- renderPlot({
    df <- crimes %>% filter(LIQUOR12 != "null", DRUG12 != "null", WEAPON12 != "null", MEN_TOTAL != "null", TOTAL!="null")
    
    #df$MEN_TOTAL <- as.numeric(as.character(df$MEN_TOTAL))
    df$LIQUOR12 <- as.numeric(as.character(df$LIQUOR12))
    df$DRUG12 <- as.numeric(as.character(df$DRUG12))
    df$WEAPON12 <- as.numeric(as.character(df$WEAPON12))
    df$TOTAL <- as.numeric(as.character(df$TOTAL))
    df$MEN_TOTAL <- as.numeric(as.character(df$MEN_TOTAL))
    df$RATIO <- df$MEN_TOTAL / df$TOTAL
    df$RATE <- (df$LIQUOR12 + df$DRUG12 + df$WEAPON12) / df$TOTAL
    
    avg_crimeRate = mean(df$RATE)
    
    ggplot() + 
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous() +
      labs(title='Residence Hall Crime Rates') +
      labs(x="Percent Men", y=paste("Crime Rate")) +
      layer(data=df, 
            mapping=aes(x=RATIO, y=RATE), 
            stat="identity", 
            stat_params=list(), 
            geom="point",
            geom_params=list()
            
      )+ 
      geom_hline(yintercept=avg_crimeRate)
  })
  
  output$barChart <- renderPlot({
    df1 <- crimes %>% group_by(INSTNM) %>% filter(LIQUOR12 != 0, DRUG12 != 0, WEAPON12 !=0) %>% filter(LIQUOR12 != "null", DRUG12 != "null", WEAPON12 != "null")
    
    df1$LIQUOR12 <- as.numeric(as.character(df1$LIQUOR12))
    df1$DRUG12 <- as.numeric(as.character(df1$DRUG12))
    df1$WEAPON12 <- as.numeric(as.character(df1$WEAPON12))
    
    df1 <- melt(df1[,c('INSTNM','LIQUOR12','DRUG12', 'WEAPON12')],id.vars = "INSTNM")
    df1$value <- as.numeric(as.character(df1$value))
    
    ggplot(df1, aes(INSTNM, value)) +   
      geom_bar(aes(fill = variable), position = "dodge", stat="identity") +
      coord_flip()
  })

  output$crosstab <- renderPlot({
    
    KPI_Low_Max_value = 0.0018     
    KPI_Medium_Max_value = 0.01
    
    df2 <- crimes %>% group_by(INSTNM) %>% filter(LIQUOR12 != "null", DRUG12 != "null", WEAPON12 != "null", TOTAL != "null")
    
    df2$LIQUOR12 <- as.numeric(as.character(df2$LIQUOR12))
    df2$DRUG12 <- as.numeric(as.character(df2$DRUG12))
    df2$WEAPON12 <- as.numeric(as.character(df2$WEAPON12))
    df2$TOTAL <- as.numeric(as.character(df2$TOTAL))
    
    df2 <- df2 %>% filter(SECTOR_DESC %in% c('Private nonprofit, 4-year or above','Private for-profit, 4-year or above','Public, 4-year or above')) %>%group_by(SECTOR_DESC, STATE) %>% mutate(crime_rate = (DRUG12 + WEAPON12 + LIQUOR12) / TOTAL) %>% mutate(kpi = ifelse(crime_rate <= KPI_Low_Max_value, '03 Low', ifelse(crime_rate <= KPI_Medium_Max_value, '02 Medium', '01 High'))) 
    
    ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_discrete() +
      labs(title='KPI of Crime Rate') +
      labs(x=paste("Type of University"), y=paste("State")) +
      layer(data=df2, 
            mapping=aes(x=SECTOR_DESC, y=STATE, label=LIQUOR12), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=0, size=3), 
            position=position_identity()
      ) +
      layer(data=df2, 
            mapping=aes(x=SECTOR_DESC, y=STATE, label=DRUG12), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=8, size=3), 
            position=position_identity()
      ) +
      layer(data=df2, 
            mapping=aes(x=SECTOR_DESC, y=STATE, label=DRUG12), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", hjust=16, size=3),
            position=position_identity()
      ) +
      layer(data=df2, 
            mapping=aes(x=SECTOR_DESC, y=STATE, fill=kpi), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha=0.50), 
            position=position_identity()
      )
  })

  # End your code here.
  return(plot)
})
