SBERBANK Opendata plotter
========================================================
author: Ilya Krasnikov
date: 03.08.2017
autosize: true

Overview
========================================================

This presentation was prepared for the **Course Project: Shiny Application and Reproducible Pitch**

The shiny app developed for this assignment is avalilable: https://drpooh.shinyapps.io/Sberbank_Opendata/

The source codes of ui.R and server.R and also Rpresentation are available on the GitHub repo: https://github.com/ivkrasnikov/Shiny-Application-and-Reproducible-Pitch/

Introduction
========================================================

Sberbank occupies 40% to 90% of the financial services market, depending on the region and product in Russia. It analyze data on 140 million private and 1.5 million corporate customers.
"Big Data" of Sberbank is information about partial economic processes taking place in the country. For the first time, these data become available at [Opendata Sberbank](http://www.sberbank.com/ru/opendata) and [Official site on English](http://www.sberbank.com)

Available data
========================================================

* Revenue of legal entities by industries and regions
* The income level of the population - salaries, pensions, grants, allowances
* Propensity to save and consume
* Level of crediting in different regions
* Mobility of the population at home and abroad
* The share of expenses for food, housing and communal services, transport and other items

ui.R code
========================================================


```r
library(shiny)
shinyUI(fluidPage(
  titlePanel("Sberbank Open Data"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("region"),
      uiOutput("rname"),
      uiOutput("period")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("text1")),
      plotlyOutput("distPlot")
    )
  ))
)
```

server.R code
========================================================


```r
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
```

Sample Grafic generated from the app
========================================================

![Main screenshot](Presentation-figure/sample.png)

Here is the screenshot of a sample analysis performed with the shiny app. The app has several inputs to manipulate the data and plot. A user can select a measurement, region and period. 