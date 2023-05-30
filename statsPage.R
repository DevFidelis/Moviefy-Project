statsPageUi <- tags$div(
  dashboardSidebar("Stats"),
  dashboardBody(
    fluidRow(
      box(
        title = "Average rating",
        verbatimTextOutput("average1")
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
      fluidRow(
        box(
          title = "Average rating",
          plotOutput("average")
        )
      ),
      fluidRow(
        box(
          title = "Most Viewed",
          plotOutput("most_rated")
        )
      ),
      fluidRow(
        box(
          title = "Avarage Rating",
          plotOutput("histogram")
        )
      )
    
    )
  )
)

