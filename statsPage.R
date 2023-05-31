statsPageUi <- tags$div(
  dashboardSidebar("Stats"),
  dashboardBody(
    fluidRow(
      box(
        title = "Rating Statistics",
        verbatimTextOutput("summary_stats")
      ),
      fluidRow(
        box(
          title = "Movie Statistics",
          verbatimTextOutput("movie_summary")
        )
      ),
      fluidRow(
        box(
          title = "Normalized Heatmap",
          plotOutput("average")
        )
      ),
      fluidRow(
        box(
          title = "Heatmap",
          plotOutput("average2")
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

