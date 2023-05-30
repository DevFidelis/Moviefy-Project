footer <- tags$script(src = "welcome.js")
library(shiny)
ui <- fluidPage(
  titlePanel("moviefy"),
  sidebarLayout(
    sidebarPanel(
      textInput("user", "Enter User Name:", ""),
      actionButton("recommendBtn", "Recommend Movies")
    ),

    mainPanel(
      verbatimTextOutput("recommendation"),
      tags$hr(),
      p("Visit our website for more movie recommendations!"),
      p("follow us on twitter , instagram and Facebook name moviefy!"),
      p("sign up and provide us with your emails so we can directly send you emails on trending movies .!"),
      tags$hr(),
      p("Contact us: cossamsoko7@gmail.com | Phone:0966652342"),
      tags$hr(),
      p("Disclaimer: The movie recommendations provided in this app are based on user preferences and may not reflect personal preferences or guarantee satisfaction."),
      tags$hr(),
      p("Version 1.0"),
      tags$hr(),
      p(" developed by fidelis , musengah , blessings , cossam and chellah")
    
   )
  )
)

server <- function(input, output) {
  # Server logic
  # ...
}

shinyApp(ui, server)
