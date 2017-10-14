library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sberbank Open Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      uiOutput("region"),
      uiOutput("rname"),
      
      radioButtons("period", "Choose a period:", 
                   c("Date range"="mon",
                     "Years" = "year",
                     "From the year begin" = "yearbegin",
                     "All the time" = "all"),
                   selected = "all"),
      uiOutput("slider1"),
      uiOutput("slider2"),
      uiOutput("dates"),
      checkboxGroupInput("chkGroup", label = h3("Geom smooth"), 
                         choices = list("Auto" = 1, "Linear model" = 2, "Poly Model" = 3),
                         selected = 1)
    ),
    
                   
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("text1")),
      plotlyOutput("distPlot")
    )
  ),
  
  hr(),
  
  fluidRow(
    column(4, h3("Sberbank Open Data plotting tool"), h5("by Ilya Krasnikov")),
    column(6, 
          h3("Synopsis"),
          p("Sberbank occupies 40% to 90% of the financial services market, depending on the region and product in Russia. It analyze data on 140 million private and 1.5 million corporate customers."),
          p("Big Data of Sberbank is information about partial economic processes taking place in the country. For the first time, these data become available 
             at ", a("Opendata Sberbank", href = "http://www.sberbank.com/ru/opendata"), (" and "), a("Official site on English", href="http://www.sberbank.com") ),
          h3("Instructions"),
          p("The app has several inputs to manipulate the data and plot. A user can select a measurement, region and period."),
          HTML("<ol>
                <li>Select a region of interest</li>
                <li>Select a variable (information about partial economic processes)</li>
                <li>Select a period of interest:</li>
                <ul>
                  <li>Date range - specifies the begining date and end dates of showing data</li>
                  <li>Years - a slider that specifies the years of showing data</li>
                  <li>From the year begin - a slider that specifies from the begin of which year to show the data</li>
                  <li>Finally, All the time - showing the data for all the time</li>
                </ul>
               </ol>"),
          
          p("The user also could select an approximation model for the showing data:"),
          HTML("<ul>
                  <li>Auto - the plot generates an approximation curve automatically</li>
                  <li>Linear model - the plot generates Linear approximation model curve</li>
                  <li>Poly model - the plot generates polynom model curve for the presented data</li>
                </ul>")
          )
           
  )
  
)
)
