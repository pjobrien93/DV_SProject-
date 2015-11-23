library(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter Plot", tabName = "scatter", icon = icon("dashboard")),
      menuItem("Barchart", tabName = "barchart", icon = icon("th")),
      menuItem("Crosstab", tabName = "crosstab", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "scatter",
              plotOutput("scatterPlot")
              
      )
  #    tabItem(tabName = "crosstab"),
  #            sidebarPanel(
  #              actionButton(inputId = "light", label = "Light"),
  #              actionButton(inputId = "dark", label = "Dark"),
  #              sliderInput("KPI1", "KPI_Low_Max_value:", 
  #                          min = 0, max = 0.01,  value = 0.0018),
  #              sliderInput("KPI2", "KPI_Medium_Max_value:", 
  #                          min = 0.01, max = 0.02,  value = 0.01),
  #              textInput(inputId = "title", 
  #                        label = "Crosstab Title",
  #                        value = "Crosstab"),
  #              actionButton(inputId = "clicks2",  label = "Click me"),
  #            ),
  #           plotOutput("crosstab")
    )
  )
)

