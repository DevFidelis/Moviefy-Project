# UI for the homepage
homePageUi <- tags$div(
  class = "push-down",
  sidebarPanel( 
    style = "text-align:center; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
    tags$img(src = "search.png", style = "width:150px;height:auto;", alt = "Image loading..."),
    tags$h3("Search For Movies"),
    tags$p("Here you can search for movies based on the avarage ratings of the users and the genre of the movies."),
    selectInput("genre", "Select Genre:", choices = NULL),
    selectInput("rating", "Select Rating:", choices = c(1.0, 2.0, 3.0, 4.0, 5.0)),
    actionButton("submit", "Filter Movies")
  ),
  mainPanel(
    dataTableOutput("moviesTable")
  )
)