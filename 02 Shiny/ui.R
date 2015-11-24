library(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(title = "Project 6: Residence Hall Crime Data", titleWidth = 450
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter Plot", tabName = "scatter", icon = icon("th")),
      menuItem("Barchart", tabName = "barchart", icon = icon("bar-chart")),
      menuItem("Crosstab", tabName = "crosstab", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "scatter",
              plotOutput("scatterPlot")
      ),
      tabItem(tabName = "barchart",
              plotOutput("barChart")
        
      ),
      tabItem(tabName = "crosstab",
            plotOutput("crosstab")
    )
  )
)
)