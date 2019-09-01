
##libraries-----------------------------------------------------------------------------------------------
library(shiny)
library(dplyr)
library(tidyr)
#library(knitr)
library(ggplot2)
library(scales)
library(lubridate)
library(forcats)
#library(plotly)
library(RODBC)
library(scales)
library(shinythemes)
#library(grid)
library(gridExtra)
#library(lattice)

shinyServer(
  function(input, output, session) 
  {

    ##dataload----------------------------------------------------------------------
    diamonds_tibble <- as_tibble(diamonds)
    
    ##functions---------------------------------------------------------------------
    
    ##this adds the £ sign to values ie pounds(x) would result to £x
    pounds <- dollar_format(prefix = "£", largest_with_cents = 1e+06)
    
    ##graph functions--------------------------------------------------------------
    
    my_main_theme <- theme_bw()+theme(axis.text=element_text(size = 12.5), axis.title=element_text(size = 12.5), title = element_text(size = 11), legend.title = element_text(size = 12.5), legend.text = element_text(size = 12.5))
    
    ##bargraph function
    bargraph_toplevel <- function(data,xvariable,yvariable) 
    {
      output <- ggplot(data, aes_string(x = xvariable, y = yvariable, colour = xvariable, fill = xvariable))+
        geom_bar(stat="identity")+
        my_main_theme+
        theme(legend.position = "None")
      return(output)
    }
    
    ##filters-----------------------------------------------------------------------
    
    ##color filter
    color_filter <-  diamonds_tibble%>%
      distinct(color)%>%
      pull()%>% ## essential as when you don't use pull, it gives you the data in column form
      as.character()
    
    color_list <- c("All", color_filter)
    
    ##clarity filter
    clarity_filter <- diamonds%>%
      distinct(clarity)%>%
      pull()%>% ## essential as when you don't use pull, it gives you the data in column form
      as.character()
    
    clarity_list <- c("All", clarity_filter)
    
    ##side filters--------------------------------------------------------------
    output$Color <- renderUI({
      selectInput("Color", "Choose color:", as.list(color_list))
    })
    
    output$Clarity <- renderUI({
      selectInput("Clarity", "Choose clarity:", as.list(clarity_list))
    })
    
    
    ##reactive table-------------------------------------------------------------
    ##table to analyse average depth and price of different cuts of diamonds
    diamonds_table_reactive <- reactive({
      diamonds_cut_table <- diamonds%>%
      filter(if (input$Color == "All") color == color else color == input$Color)%>%
      filter(if (input$Clarity == "All") clarity == clarity else clarity == input$Clarity)%>%
      group_by(cut)%>%
      summarise(avg_depth = mean(depth)
                ,avg_price = pounds(mean(price))
                ,avg_table = mean(table)
                ,avg_x = mean(x)
                ,avg_y = mean(y)
                ,avg_z = mean(z)
                )
    })
    
    ##outputs---------------------------------------------------------------------
    ##summary table
    output$diamonds_table <- renderTable ({
      diamonds_table_reactive()
    })
    
    ##average price graph
    output$price_graph <- renderPlot({
      
      diamonds_table <- diamonds_table_reactive()
      
      bargraph_toplevel(diamonds_table, "cut", "avg_price")+
        labs(x= "Cut Type", y= "Average Price")+
        geom_text(aes(y = avg_price, label=avg_price), size = 7, vjust = 3,  colour= "black")
    })
    
  }) ##closing shinyServer
