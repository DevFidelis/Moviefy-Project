# import or include packages and files
source("header.R")
source("pages.R")
source("footer.R")

# Function to fetch genres from the database
getGenres <- function() {
  query <- "SELECT DISTINCT genres FROM movies"
  genres <- dbGetQuery(con, query)$genres
  unique(unlist(strsplit(genres, ", ")))
}


# user interface and rounting
ui <- fluidPage(
  pageTitles, css, header,
  # routes
  router_ui(
    route("/", homePage),
    route("tags", tagsPage),
    route("stats", statsPage)
  ), footer
)

# back-end
server <- function(input, output, session) {
  router_server()
  
  # connect to remote database
  con <- dbConnect(RMySQL::MySQL(), 
    dbname = "bvytebcmiythrl1d1icu",
    host = "bvytebcmiythrl1d1icu-mysql.services.clever-cloud.com",
    port = 3306,
    user = "u8ulpjyfa8ywgjut",
    password = "5dHXIT7aWAJ641MnIWq0")


  # Query to get movies based on filters
  getFilteredMovies <- function(genre) {
    query <- "SELECT DISTINCT title, genres FROM movies"
    if (genre != "All") {
      query <- paste0(query, " WHERE FIND_IN_SET('", genre, "', genres)")
    }
    dbGetQuery(con, query)
  }
  
  # Update the displayed movies table based on filters
  observeEvent(input$filter_btn, {
    movies <- getFilteredMovies(input$genre)
    output$movies_table <- renderTable({
      movies
    })
  })
    
    # close database connection  
    dbDisconnect(con)
}

shinyApp(ui, server)
