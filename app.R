library(shiny)
# Load data, script, libraries.
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI ----
ui <- fluidPage(
    
    titlePanel("censusVis"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create demographic maps with information from the 2010 US Census."),
            
            selectInput("percent_ethnicity", 
                        label = "Choose a variable to display", 
                        choices = list("Percent White", 
                                       "Percent Black", 
                                       "Percent Hispanic", 
                                       "Percent Asian")),
            
            sliderInput("range", 
                        label = "Range of interest:", 
                        min = 0, max = 100, 
                        value = c(0, 100))
        ),
        
        mainPanel(plotOutput("map"))
    )
)

# Define server logic ----
server <- function(input, output) {
    
    output$map <- renderPlot({
        
        data <- switch(input$percent_ethnicity,
                       "Percent White" = counties$white, 
                       "Percent Black" = counties$black, 
                       "Percent Hispanic" = counties$hispanic, 
                       "Percent Asian" = counties$asian)
        
        color <- switch(input$percent_ethnicity,
                        "Percent White" = "dark green", 
                        "Percent Black" = "black", 
                        "Percent Hispanic" = "orange", 
                        "Percent Asian" = "purple")
        
        percent_map(var = data, color = color, legend.title = input$percent_ethnicity, 
                    max = input$range[2], min = input$range[1])
    })
    
}

# Run the app ----
shinyApp(ui = ui, server = server)