library(shiny)
library(datasets)
require(rCharts)
options(RCHART_WIDTH = 800)
require(ggplot2)

# We rename and clean the state dataset. Some columns were removed and others were
# renamed to make the final data frame we will be using.
state <- data.frame(state.x77)
state <- data.frame(cbind(rownames(state),state[,c(-5,-7)]))
colnames(state)[c(1,5,6)]<-c("State","Life_Expectancy","HS_Grad")


# Define server logic required to plot all the variables.
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$Chart expressions
  formulaText <- reactive({
    paste(input$y, "~", input$x)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  output$plotText <- renderText({
    text <- c("This is a plot showing the interaction between the two selected
              statistics across all 50 states. Hover on each point to see which
              state the data point belongs to and what the corresponding statistics
              values are.")
  })
  output$summaryText <- renderText({
    text <- c("This is a summary of the linear regression model that was fitted 
              to the selected variables. As you will see, some statistics are 
              more strongly related to each other than others.")
  })
  output$tableText <- renderText({
    text <- c("This is a sortable and searchable table of the original data.
              Sort by any variable to see which states fare the best and worst
              in that statistic.")
  })
  # Generate a plot of the requested variables using rCharts
  output$chart <- renderChart({
    fit <- fortify(lm(as.formula(formulaText()),data=state))
    names(fit) = gsub('\\.', '_', names(fit))
    fit <- cbind(rownames(fit),fit)
    colnames(fit)[1] <- "State"
    
    selectedfactor = fit$State
    p1 <- rPlot(as.formula(formulaText()), 
            data = fit,color='State',type='point')
    p1$layer(y = '_fitted', copy_layer = T, type = 'line',
             color = list(const = 'red'),
             tooltip = "function(item){return item._fitted}")
    p1$set(legendPosition = "none")  
    #p1$guides(color = list(numticks=length(levels(selectedfactor))))
    p1$addParams(dom = 'chart')
    return(p1)
  }) 

  output$summary <- renderPrint({
    regression <- lm(as.formula(formulaText()),data=state)
    summary(regression)
  })  
     
  output$table <- renderDataTable({
    data.frame(state)
  },options = list(bSortClasses = TRUE))  
  
  output$help1 <- renderText({
    desc <- c("This is a fun little application that allows you to select
              US states statistics whose interaction you would like to 
              observe. The data is based on the U.S. Department of Commerce, 
              Bureau of the Census (1977) Statistical Abstract of the United 
              States.")
  })
  output$help2 <- renderText({
    desc2 <- c("You can select any two variable whose interaction you can
               observe by selecting from the drop down menu. The 'Plot' tab
               plots an interactive plot of how the selected variables interact.
               You can hover on the points plotted to see what state they belong
               to and what values they correspond to. The red line on the plot
               is the fitted regression line. \n\n The 'Summary' tab shows the
               summary of the regression model that was fitted to the data. \n\n
               Finally the 'Table' tab displays the original data in a 
               sortable and searchable data format for users to play around 
               and understand the data better.")
  })
})

