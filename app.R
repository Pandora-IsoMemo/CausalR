#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(CausalImpact)
library(ggplot2)
library(readxl)

ui <- fluidPage(
  titlePanel("MPI Causal Impact Dashboard"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload File"),
      checkboxInput("header", "Header", TRUE),
      numericInput("min_pre_period", "Minimum Pre-Period Value", value = 1),
      numericInput("max_pre_period", "Maximum Pre-Period Value", value = 70),
      numericInput("min_post_period", "Minimum Post-Period Value", value = 71),
      numericInput("max_post_period", "Maximum Post-Period Value", value = 100),
      actionButton("go", "Model")
    ),
    mainPanel(
      plotOutput("cumulative_plot"),
      verbatimTextOutput("results")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    req(input$file)
    inFile <- input$file
    if (endsWith(inFile$name, ".csv")) {
      df <- read.csv(inFile$datapath, header = input$header)
    } else if (endsWith(inFile$name, ".xlsx") || endsWith(inFile$name, ".xls")) {
      df <- read_excel(inFile$datapath)
    } else {
      return(NULL)
    }
    df[] <- lapply(df, as.numeric)
    df
  })
  
  pre_period <- reactive({c(input$min_pre_period, input$max_pre_period)})
  
  post_period <- reactive({c(input$min_post_period, input$max_post_period)})
  
  impact_model <- eventReactive(input$go, {
    if (is.null(data())) return(NULL)
    CausalImpact(data(), pre_period(), post_period())
  })
  
  output$cumulative_plot <- renderPlot({
    if (is.null(impact_model())) return(NULL)
    plot(impact_model())
  })
  
  output$results <- renderPrint({
    if (is.null(impact_model())) return(NULL)
    summary(impact_model())
    writeLines("\nINTERPRETATION: \n")
    summary(impact_model(), 'report')
  })
}

shinyApp(ui = ui, server = server)

