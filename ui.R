library(shiny)
require(rCharts)
require(ggplot2)
options(RCHART_LIB = 'polycharts')


shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("US States Census Statistics (as of 1975)"),
  
  sidebarPanel(selectInput("x", "X-axis:",
                           list("State Population in hundred thousand" = "Population", 
                                "Per capita Income" = "Income", 
                                "Illiteracy (percent of population)" = "Illiteracy",
                                "Life Expectancy in years"="Life_Expectancy",
                                "Percent High School Grads"="HS_Grad",
                                "Area"="Area")),
               
               selectInput("y", "Y-axis:",
                           list("State Population in hundred thousand" = "Population", 
                                "Per capita Income" = "Income", 
                                "Illiteracy (percent of population)" = "Illiteracy",
                                "Life Expectancy in years"="Life_Expectancy",
                                "Percent High School Grads"="HS_Grad",
                                "Area"="Area"))
               
               
  ),
  
  #Creating tabs
  mainPanel(tabsetPanel(
    tabPanel("Plot", h3(textOutput("caption")),textOutput("plotText"),showOutput("chart", "polycharts")),
    tabPanel("Summary",p("\n"),textOutput("summaryText"),p("\n"),verbatimTextOutput("summary")),
    tabPanel("Table",p("\n"),textOutput("tableText"),p("\n"), dataTableOutput("table")),
    tabPanel("Read Me",h4("About this application"),textOutput("help1"),h4("Function"),textOutput("help2"))
  ))
))
