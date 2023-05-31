# import or include packages and files
source("header.R")
source("pages.R")

# user interface and routing
ui <- fluidPage(
  pageTitles, css, header,
  # routes
  router_ui(
    route("/", homePage),
    route("tags", tagsPage),
    route("stats", statsPage)
  )
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
  
  # # stats
  # query2 <- sprintf("SELECT * FROM movies")
  # query1 <- sprintf("SELECT * FROM ratings")

  data2 <- dbGetQuery(con, query2)
  data1 <-    dbGetQuery(con, query1)    
  
  # Summary of the ratings
  output$summary_stats <- renderPrint({
    summary(data1)
  })
  # Summary of the ratings
  output$movie_summary <- renderPrint(
    summary(data2)
  )  

  
#Heatmap of top users and movies
  output$average2 <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    movie_rating <- ratingMatrix[rowCounts(ratingMatrix) > 50, colCounts(ratingMatrix) >50]
    minimum_movies <- quantile(rowCounts(movie_rating), 0.98)
    minimum_users <- quantile(colCounts(movie_rating), 0.98)
    normalized_rating <- normalize(movie_rating)
    sum(rowMeans(normalized_rating) > 0.00001)
    image(ratingMatrix[1:30,1:30], axes = FALSE, main = "30 X 30 heatmap")
  })
  
#plots the average rating per user
  output$histogram <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    movie_rating <- ratingMatrix[rowCounts(ratingMatrix) > 50, colCounts(ratingMatrix) >50]
    minimum_movies <- quantile(rowCounts(movie_rating), 0.98)
    minimum_users <- quantile(colCounts(movie_rating), 0.98)
    normalized_rating <- normalize(movie_rating)
    sum(rowMeans(normalized_rating) > 0.00001)
    average_rating <- rowMeans(movie_rating)
    qplot(average_rating, fill=I('steelblue'), col=I("red"))+
     ggtitle("distribution of the average rating per user")

  })
  
#plots the first 6 most watched movies
  output$most_rated <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    movie_view <- colCounts(ratingMatrix)
    table_view <- data.frame(movie = names(movie_view), views = movie_view)
    table_view <- table_view[order(table_view$views, decreasing = TRUE), ]
    table_view$title <- NA
    for(index in 1:9000){
      table_view[index, 3] <- as.character(subset(data2,
                                                  data2$movieId == table_view[index, 1])$title)
    }
    ggplot(table_view[1:6,], aes(x = title, y = views)) +
      geom_bar(stat = "identity", fill = 'steelblue') +
      geom_text(aes(label=views), vjust=-0.3, size=3.5) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("total views of films")
  
  # Update current page when pagination link is clicked
  observeEvent(input$currentPage, {
    currentPage(input$currentPage)
  })
  
  #plots the normalize heatmap of top users and movies
  output$average <- renderPlot({
    ratingMatrix <- dcast(data1, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingMatrix <- as.matrix(ratingMatrix[,-1])
    ratingMatrix <- as(ratingMatrix, "realRatingMatrix")
    movie_rating <- ratingMatrix[rowCounts(ratingMatrix) > 50, colCounts(ratingMatrix) >50]
    minimum_movies <- quantile(rowCounts(movie_rating), 0.98)
    minimum_users <- quantile(colCounts(movie_rating), 0.98)
    normalized_rating <- normalize(movie_rating)
    sum(rowMeans(normalized_rating) > 0.00001)
    image(normalized_rating[rowCounts(normalized_rating) > minimum_movies,
                           colCounts(normalized_rating) > minimum_users],
         main = "Normalized rating of top Users")
    
  })



  # Clean up: Disconnect from the database when the app is closed
  onStop(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui, server)
