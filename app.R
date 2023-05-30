# import or include packages and files
source("header.R")
source("pages.R")
source("footer.R")

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
    
    # close database connection  
    dbDisconnect(con)
}

shinyApp(ui, server)
