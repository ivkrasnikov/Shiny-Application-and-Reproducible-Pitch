library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sberbank Open Data"),
  
  # Sidebar with a slider input for number of bins 
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
