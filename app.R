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

# x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
# y <- 1.2 * x1 + rnorm(100)
# y[71:100] <- y[71:100] + 10
# df <- as.data.frame(cbind(y, x1))
# 
# time.points <- seq.Date(as.Date("2014-01-01"), by = 1, length.out = 100)
# df_dt <- zoo(cbind(y, x1), time.points)

ui <- fluidPage(
  titlePanel("MPI Causal Impact Dashboard"),
  sidebarLayout(
    sidebarPanel(
      
      fileInput(
        inputId = "filedata",
        label = "Upload data. Choose csv file",
        accept = c(".csv")
      ),
      checkboxInput("header", "Header", TRUE),
      # radioButtons("time_choice", "Choose Time Type", choices = c("Numeric", "Date")),
      # conditionalPanel(condition = "input.data_choice == 'Date'",
                       
                        numericInput("min_pre_period", "Minimum Pre-Period Value", value = 1),
                        numericInput("max_pre_period", "Maximum Pre-Period Value", value = 70),
                        numericInput("min_post_period", "Minimum Post-Period Value", value = 71),
                        numericInput("max_post_period", "Maximum Post-Period Value", value = 100),
      
      # conditionalPanel(condition = "input.time_choice == 'Numeric'",
      #                  numericInput("min_pre_period", "Minimum Pre-Period Value", value = 1),
      #                  numericInput("max_pre_period", "Maximum Pre-Period Value", value = 70),
      #                  numericInput("min_post_period", "Minimum Post-Period Value", value = 71),
      #                  numericInput("max_post_period", "Maximum Post-Period Value", value = 100),
      # conditionalPanel(condition = "input.data_choice == 'Example Data Set'",
      #                  selectInput("example_data", "Choose Example Data Set", choices = names(data_sets))),
      #                  numericInput("min_pre_period", "Minimum Pre-Period Value", value = 1),
      #                  numericInput("max_pre_period", "Maximum Pre-Period Value", value = 70),
      #                  numericInput("min_post_period", "Minimum Post-Period Value", value = 71),
      #                  numericInput("max_post_period", "Maximum Post-Period Value", value = 100),
      
      #selectInput("response_var", "Response Variable", choices = colnames(df)),
      #selectInput("intervention_var", "Intervention Variable", choices = colnames(df)),
      actionButton("go", "Model"),
      actionButton("reset_input", "Reset")
    ),
    mainPanel(
      #plotOutput("pre_plot"),
      #plotOutput("post_plot"),
      dataTableOutput('table'),
      plotOutput("cumulative_plot"),
      verbatimTextOutput("results")
    )
  )
)


server <- function(input, output) {
  
  # Define reactive data
  data <- reactive({
    req(input$filedata)
    read.csv(input$filedata$datapath)
  })
  
  v <- reactiveValues(doPlot = FALSE)
  observeEvent(input$go, {
   # # 0 will be coerced to FALSE
  #  # 1+ will be coerced to TRUE
  v$doPlot <- input$go
  })

  observeEvent(input$tabset, {
   v$doPlot <- FALSE
  })
  
  # Update response and intervention variable choices based on uploaded data

  
  # Define a reactive CausalImpact model
 
  impact_model <- reactive({
    model <- CausalImpact(data, c(input$min_pre_period, input$max_pre_period), c(input$min_post_period,input$max_post_period))
    return(model)
  })
  ## look at the df
  output$table <- renderTable(data())
  ## Define cumulative plot
  output$cumulative_plot <- renderPlot({
    if (v$doPlot == FALSE) return()
    #plot(CausalImpact(df, c(input$min_pre_period, input$max_pre_period), c(input$min_post_period,input$max_post_period)))
    plot(impact_model())
  })
  # Define results output
  output$results <- renderPrint({
    if (v$doPlot == FALSE) return('Click Model Button')
    summary(impact_model())
    #impact_model()$summary
    writeLines("\nINTERPRETATION: \n")
    summary(impact_model(),"report")
  })
}

shinyApp(ui = ui, server = server)