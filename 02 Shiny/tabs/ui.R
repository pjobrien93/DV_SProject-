library(shiny)

navbarPage(
  title = "Proeject 6: Residence Hall Crime",
  tabPanel(title = "Scatter Plot",
           mainPanel(plotOutput("scatterPlot"))
           ),
  tabPanel(title = "Barchart",
              mainPanel(plotOutput("barchart"))
              ),
  tabPanel(title = "Crosstab",
           mainPanel(plotOutput("crosstab"))
  )
)
