#
# THIS IS AN EXAMPLE APPLICATION IT WILL NOT RUN

library(shiny)
library(DBI)

# You should always store credentials and keys in a JSON or RENVIRON file
creds <- fromJSON(".creds.json")

# Create the DB Connection
conn <- dbConnect(odbc::odbc(), driver = "FreeTDS", server = "IP_or_HOST_ADDRESS", port = 1433, database = "DBName", uid = creds$un, pwd = creds$pw, TDS_Version = "8.0")

# Reminder Broken example
selections <- sort(dbGetQuery(conn, "SELECT DISTINCT(TYPE) FROM Database.dbo.Things")$TYPE)

# Define UI for application
ui <- fluidPage(
   
   # Application title
   titlePanel("Database Dashboard"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sdateRangeInput("dates",
                         "Select Dates",
                         start = Sys.Date()-30,
                         end = Sys.Date()),
         selectInput("select",
                     "Selections",
                     choices = selections,
                     selected = "Some Type")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("examplePlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   dataLoad <- reactive({
     # Generate SQL Statement
     sql <- paste0("SELECT * FROM SOME_DATABASE WHERE DATE_COLUMN >= '", input$dates[1], "' AND DATE_COLUMN <= '", input$dates[2], "' AND TYPE = ", input$select)
     # Run SQL Statement
     data <- dbGetQuery(conn, sql)
     
     return(data)
   })
   output$examplePlot <- renderPlot({
     ggplot(table, aes(x = STATUS, y = count, fill = STATUS)) +
       geom_bar(stat = "identity")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

