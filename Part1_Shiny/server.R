library(shiny)
library(plotly)
library(lubridate)


shinyServer(
  
  function(input, output) {

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
  
  # output$value <- renderPrint({ input$slider })
  
  output$slider1 <- renderUI({
    if (input$period == "yearbegin"){
      sliderInput("slider1", label = "From year", min = 2013, max = 2017, value = 2016, sep = "")
    }
  })
  
  output$slider2 <- renderUI({
      if (input$period == "year"){
      sliderInput("slider2", label = "Years range", min = 2013, max = 2017, value = c(2015,2016), sep = "")
    }
  })
  
  output$dates <- renderUI({
    if (input$period == "mon"){
      dateRangeInput("dates", label = "Date range", start = "2013-01-01", end = "2017-04-14", 
                     min = "2013-01-01", max = "2017-04-14")
    }
  })
  
  output$distPlot <- renderPlotly({
    if (input$period == "all")
    {
      dt <- data[data$region == input$region & data$name == input$rname, ]
    }
    if (input$period == "yearbegin")
    {
      sl <- input$slider1
      year <- as.character(sl)
      d <- as.Date(paste(year,"-01-01", sep=""))
      
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d, ]
    }
    if (input$period == "year")
    {
      # d <- as.Date('2017-04-14')
      # d <- d %m+% years(-1)
      sl <- input$slider2
      year1 <- as.character(sl[1])
      year2 <- as.character(sl[2])
      d1 <- as.Date(paste(year1,"-01-01",sep=""))
      d2 <- as.Date(paste(year2,"-01-01",sep=""))
      
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d1 & data$date <= d2, ]
    }
    if (input$period == "mon")
    {
      # d <- as.Date('2017-04-14')
      # d <- d %m+% months(-1)
      d1 <- as.Date(input$dates[1])
      d2 <- as.Date(input$dates[2])
      dt <- data[data$region == input$region & data$name == input$rname & data$date >= d1, ]
    }
    
    #plot_ly(x=~date, y=~value, data=dt, type = 'scatter', mode = 'lines')
    p <- ggplot(data = dt, aes(x=date, y=value)) + geom_line()

    if ("1" %in% input$chkGroup)
      p <- p + geom_smooth(method = "loess", aes(color="Auto Model"))
    if ("2" %in% input$chkGroup)
      p <- p + geom_smooth(method = "glm", aes(color="Linear Model"), formula = y~x)
    if ("3" %in% input$chkGroup)
      p <- p + geom_smooth(method = "glm", aes(color="Poly Model"), formula= (y ~ poly(x,2)), linetype = 1)
                           
    p <- ggplotly(p)
  })
  
})
