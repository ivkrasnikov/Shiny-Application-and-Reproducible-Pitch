library(shiny)
library(plotly)
library(lubridate)


shinyServer(function(input, output) {

  data <- read.csv("opendata.csv", sep = ',', quote = '"', dec = '.', stringsAsFactors = FALSE)
  data$date <- as.Date(data$date, "%Y-%m-%d")
  
  output$region <- renderUI({
    selectInput("region", "Choose a region:", as.list(unique(data$region)), selected = levels(data$region)[60] ) 
  })
  
  output$rname <- renderUI({
    selectInput("rname", "Choose a variable:", as.list(unique(data$name)), selected = levels(data$name)[1]) 
  })  
  
  output$text1 <- renderText({ 
    paste("You have selected: ", input$rname, " in ", input$region)
  })
  
  output$period <- renderUI({
    radioButtons("period", "Choose a period:", 
                c("Month"="mon",
                  "Year" = "year",
                  "From the year begin" = "yearbegin",
                  "All the time" = "all"),
                selected = "all")
  })
  
  output$distPlot <- renderPlotly({
    if (input$period == "all")
    {
      dt <- data[data$region == input$region & data$name == input$rname, ]
    }
    if (input$period == "yearbegin")
    {
      d <- as.Date('2017-01-01')
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d, ]
    }
    if (input$period == "year")
    {
      d <- as.Date('2017-04-14')
      d <- d %m+% years(-1)
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d, ]
    }
    if (input$period == "mon")
    {
      d <- as.Date('2017-04-14')
      d <- d %m+% months(-1)
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d, ]
    }
    
    plot_ly(x=~date, y=~value, data=dt, type = 'scatter', mode = 'lines')
    
  })
  
})
