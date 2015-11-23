library(shiny)
require(shinydashboard)
require(leaflet)

shinyUI(fluidPage(
  titlePanel("Residence Hall Crimes"),
  plotOutput("scatterPlot")
  
  ))