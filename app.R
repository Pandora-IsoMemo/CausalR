# AUTHOR: Jianyin Roachell
# CONTACT: roachell@shh.mpg.de

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
  shiny::fluidRow(
    shinydashboard::box(
      shiny::actionButton(inputId='ab1', label="Need Help?", 
                          icon = icon("th"), 
                          onclick ="window.open('https://github.com/Pandora-IsoMemo/CausalR/blob/main/HELP.pdf', '_blank')")
    )
  ),
  titlePanel("MPI Causal Impact Dashboard"), # : ISSUE - Date ranges are not subseting the df correctly, look at date formating
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload File"),
      checkboxInput("header", "Header", TRUE),
      checkboxInput("treat_dates", "Treat periods as dates"),
      numericInput("min_pre_period", "Minimum Pre-Period Index Value", value = 1),
      numericInput("max_pre_period", "Maximum Pre-Period Index Value", value = 70),
      numericInput("min_post_period", "Minimum Post-Period Index Value", value = 71),
      numericInput("max_post_period", "Maximum Post-Period Index Value", value = 100),
      conditionalPanel(
        condition = "input.treat_dates",
        dateInput("min_pre_period_date", "Minimum Pre-Period Date","2014-01-01"),
        dateInput("max_pre_period_date", "Maximum Pre-Period Date","2014-03-11"),
        dateInput("min_post_period_date", "Minimum Post-Period Date","2014-03-12"),
        dateInput("max_post_period_date", "Maximum Post-Period Date","2014-04-10")
      ),
      actionButton("go", "Model"), 
      br(),
      br(),
      tableOutput("table")
    ),
    mainPanel(
      plotOutput("matplot"),
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
    if (input$treat_dates){
      return(df)
    } else {
    df = subset(df, select = c(y,x1) )
    return(df)
    }
  })
  
    pre_period <- reactive({
      min_pre <- input$min_pre_period
      max_pre <- input$max_pre_period
      if (input$treat_dates) {
        min_pre <- as.Date(input$min_pre_period_date)
        max_pre <- as.Date(input$max_pre_period_date)
      }
      c(min_pre, max_pre)
    })

    post_period <- reactive({
      min_post <- input$min_post_period
      max_post <- input$max_post_period
      if (input$treat_dates) {
        min_post <- as.Date(input$min_post_period_date)
        max_post <- as.Date(input$max_post_period_date)
      }
      c(min_post, max_post)
    })
  # pre_period <- reactive({c(input$min_pre_period, input$max_pre_period)})
  # post_period <- reactive({c(input$min_post_period, input$max_post_period)})
  
  impact_model <- eventReactive(input$go, {
    if (is.null(data())) return(NULL)
    
    if (input$treat_dates) {
      dataTime <- zoo(cbind(data()$y,data()$x1),as.Date(data()$date))
      return(CausalImpact(dataTime, pre_period(), post_period()))
    }
    return(CausalImpact(data(), pre_period(), post_period()))
  })
  
  output$matplot <- renderPlot({
    if (is.null(data())) return(NULL)
    matplot(data(),type='l',main = "Time Series Intervention")
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
  
  output$table <- renderTable(head(data()))
}

shinyApp(ui = ui, server = server)
