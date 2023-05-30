# UI for the homepage
homePageUi <- tags$div(
  class = "push-down",
  sidebarPanel(
    selectInput("genre", "Select Genre:", choices = NULL),
    selectInput("rating", "Select Rating:", choices = c(1.0, 2.0, 3.0, 4.0, 5.0)),
    actionButton("submit", "Filter Movies")
  ),
  mainPanel(
    dataTableOutput("moviesTable")
  )
)