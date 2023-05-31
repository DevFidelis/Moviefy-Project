statsPageUi <- tags$div(
    class = "push-down",
    style = "width:100%;",
    fluidRow(
      column(
        width = 12,
        box(
          title = "Heatmap",
          plotOutput("average2")
        )
      ),
      column(
        width = 12,
        box(
          title = "Normalized Heatmap",
          plotOutput("average")
        )
      )
    ),
    fluidRow(
      column(
        width = 12,
        box(
          title = "Avarage Rating",
          plotOutput("histogram")
        )
      ),
      column(
        width = 12,
        box(
          title = "Most Viewed",
          plotOutput("most_rated")
        )
      )
    ),
    fluidRow(
      column(
        width = 12,
        box(
          title = "Rating Statistics",
          verbatimTextOutput("summary_stats")
        )
      ),
      column(
        width = 12,
        box(
          title = "Movie Statistics",
          verbatimTextOutput("movie_summary")
        )
      )
    )
)
