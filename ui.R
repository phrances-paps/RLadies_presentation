##libraries---------------------------------------------------------------------------------------------
library(shiny)
library(dplyr)
library(tidyr)
library(knitr)
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
library(shinydashboard)

##User Interface----------------------------------------------------------------------------------------------
shinyUI( ## starts the user interface part of the dashboard code
  fluidPage( ##this ensures that the elements in the dashboard are aligned
    theme = shinytheme("cerulean"), ##https://rstudio.github.io/shinythemes/ : link for different R shiny theme
    dashboardPage(
      title = "Diamonds", ## adds a title to the html
      
      ##this is the title that appears on the dashboard header
      dashboardHeader(title = span("Diamonds", 
                                   style = "color: white; font-size: 28px;position: fixed; overflow: visible;"), titleWidth = 2000
      ),
      
      ##I disabled this as I don't want a sidebar to appear on the dashboard
      dashboardSidebar(disable = TRUE
      ),
      
      ##this just defines what the Body of the dashboard looks like/appear
      dashboardBody(
        ##these are css codes that changes the appearance of the dashboard
        tags$head(tags$style(HTML('
                                  .main-header .logo {
                                  font-family: "Calibri";
                                  font-weight: bold;
                                  font-size: 24px;
                                  text-align: left;
                                  position: fixed; overflow: visible
                                  }
                                  .skin-blue .main-header .logo {
                                  height:50px;background-color: #3c8dbc;
                                  position: fixed; overflow: visible;
                                  }
                                  .skin-blue .main-header .logo {
                                  height:50px;background-color: #3c8dbc;
                                  position: fixed; overflow: visible;
                                  }
                                  
                                  tr
                                  {
                                  background-color:#FAEBD7;
                                  color:black;
                                  }
                                  th
                                  {
                                  background-color:#B0C4DE;
                                  color:black;
                                  }
                                  
                                  .skin-blue .left-side, .skin-blue .main-sidebar, .skin-blue .wrapper {
                                  background-color: #ecf0f5 !important;}
                                  '))
        ), ##closing tags/html/css
        
        ##these are the filters that can be found at the side panel
        sidebarPanel(
          width = 4, 
          style = "position: fixed; overflow: visible;  width: 360px; height: 300px;",
          
          h3("Choose your filter"),
          
          ##color filter
          uiOutput("Color"), ##this relies on the queries that's why it's an 'output'
          
          ##clarity filter
          uiOutput("Clarity") ##this relies on the queries that's why it's an 'output'
          
          
        ), ##closing sidebarPanel
        
        mainPanel( 
          width = 8, 
          ##you can see the tab name after tabPanel() ie. tabPanel("hello") has tab name hello
          tabsetPanel(
            type = "tabs",
            tabPanel("Summary", 
                     box(
                       h3("Diamonds Summary Table"),
                       tableOutput("diamonds_table"),
                       width = 900, height = 300
                     ),
                     box(
                       h3("Cut type by average price graph"),
                       plotOutput("price_graph"),
                       width = 900, height = 500
                     )
            )##closing tabPanel
            
          )##closing tabsetPanel
          
        )##closing mainPanel
        
        )##closing dashboardBody
      
        )##closing dashboardPage
        )##closing fluidPage
    )##closing shinyUI
