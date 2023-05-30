# import or include packages and files
source("header.R")
source("pages.R")
source("footer.R")

# user interface and routing
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
    
  # Retrieve genres from the remote database
  genres <- reactive({
    query <- "SELECT DISTINCT genres FROM movies"
    result <- tryCatch({
      dbGetQuery(con, query)$genres
    }, error = function(e) {
      NULL
    })
    as.list(result)
  })
  
  # Update selectInput choices with retrieved genres
  observe({
    updateSelectInput(session, "genre", choices = genres())
  })
  
  # Retrieve movies based on selected genre and average ratings
  movies <- eventReactive(input$submit, {
    selected_genre <- input$genre
    selected_rating <- as.numeric(input$rating)
    
    if (is.null(selected_genre) || selected_genre == "" || is.null(selected_rating) || is.na(selected_rating)) {
      return(NULL)
    }
    
    query <- paste0("SELECT m.* FROM movies m JOIN (SELECT movieId, AVG(rating) AS avg_rating FROM ratings GROUP BY movieId) r ON m.movieId = r.movieId WHERE m.genres LIKE '%", selected_genre, "%' AND r.avg_rating = ", selected_rating)
    result <- tryCatch({
      dbGetQuery(con, query)
    }, error = function(e) {
      NULL
    })
    result
  })
  
  # Display the list of movies
  output$moviesTable <- renderDataTable({
    movies()
  })
  
  # stats
  query2 <- sprintf("SELECT * FROM movies")
  query1 <- sprintf("SELECT * FROM ratings")

  data2 <- dbGetQuery(con, query2)
  data1 <-    dbGetQuery(con, query1)    

  # stats
  output$data_preview <- renderTable({
    head(data1)
  })

  output$data_preview2 <- renderTable({
    head(data2)
  })

  output$summary_stats <- renderPrint({
    summary(data1)
  })

  output$histogram <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    similarity_matrix <- similarity(ratingMatrix[1:4, ], method = "cosine", which= "user")
    image(as.matrix(similarity_matrix), main = "Users Similarity") 
  })

  output$most_rated <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    movie_view <- colCounts(ratingMatrix)
    table_view <- data.frame(movie = names(movie_view), views = movie_view)
    table_view <- table_view[order(table_view$views, decreasing = TRUE), ]
    
    table_view$title <- NA
    #iterating throught the dataset to get movie titles
    for(index in 1:9000){
      table_view[index, 3] <- as.character(subset(data2,
                                                  data2$movieId == table_view[index, 1])$title)
    }
    
    #showing it in form of a histogram
    #table_view[1:6,]
    ggplot(table_view[1:6,], aes(x = title, y = views)) +
      geom_bar(stat = "identity", fill = 'steelblue') +
      geom_text(aes(label=views), vjust=-0.3, size=3.5) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("total views of films")
  })

  output$movie_summary <- renderPrint(
    summary(data2)
  )  

  # Clean up: Disconnect from the database when the app is closed
  onStop(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui, server)
