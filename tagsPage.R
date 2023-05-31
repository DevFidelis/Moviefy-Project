# UI for the tags (user mood) page
tagsPageUi <- tags$div(
  class = "push-down",
  sidebarLayout(
    sidebarPanel(
      style = "text-align:center; box-shadow: 0 2px 4px rgba(0,0,0,0.1);",
      tags$img(src = "mood.png", style = "width:200px;height:auto;", alt = "Image loading..."),
      tags$h3("Match My Mood"),
      tags$p("Here you can select a tag according to your mood and movie recommendations will be listed based on historical user data."),
      selectizeInput("tagInput", "Select tag:", choices = NULL, multiple = FALSE),
      actionButton("fetchBtn", "Fetch Movies"),
      verbatimTextOutput("resultOutput")
    ),
    mainPanel(
      uiOutput("moviesList"),
      uiOutput("pagination")
    )
  )
)
