library(shiny)
require(shinydashboard)
require(leaflet)

shinyUI(fluidPage(
  titlePanel("Residence Hall Crimes"),
  actionButton(inputId = "clicks1",  label = "Click me"),
    plotOutput("scatterPlot")
))