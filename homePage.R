# UI for the homepage
homePageUi <-sidebarLayout(
    sidebarPanel(
      # Input fields for filters
      selectInput("genre", "Genre", choices = c("All", "")),
      actionButton("filter_btn", "Apply Filters")
    ),
    mainPanel(
      # Output table for displaying movies
      tableOutput("movies_table")
    )
  )