statsPageUi <- tags$div(
  
  dashboardHeader(title = "CSV Analyzer"),
  dashboardSidebar("Stats"),
  dashboardBody(
    fluidRow(
      box(
        title = "Rating Preview",
        tableOutput("data_preview")
      )
    ),
    fluidRow(
      box(
        title = "Movie Preview",
        tableOutput("data_preview2")
      )
    ),
    fluidRow(
      box(
        title = "Rating Statistics",
        verbatimTextOutput("summary_stats")
      ),
      fluidRow(
        box(
          title = "Movie Stats",
          verbatimTextOutput("movie_summary")
        )
      ),
      box(
        title = "Most Rated",
        plotOutput("most_rated")
      ),
      box(
        title = "Histogram",
        plotOutput("histogram")
      )
    )
  )
)

