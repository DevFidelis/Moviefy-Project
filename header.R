# import packages and include components
library(shiny)
library(shiny.router)
library(DBI)
library(RMySQL)
library(shinydashboard)
library(ggplot2)
library(recommenderlab)
library(data.table)
library(ggplot2)
library(reshape2)

# Meta Data
pageTitles <- titlePanel(title = "", windowTitle = "Moviefy - The home of movie recommendations")
css <- tags$link(rel = "stylesheet", href="style.css")

# header
header <- tags$header(
  tags$div(class = "heading",
    tags$a(href = route_link("/"), style = "color: rgb(14, 15, 44);", "Moviefy")         
  ),
  tags$div(class = "header-nav",
    tags$a(href = route_link("tags"), style = "color: #333;", class = "header-btn", "Tags"),
    tags$a(href = route_link("stats"), style = "color: #333;", class = "header-btn", "Statistics")
  )
)
