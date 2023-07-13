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
      shiny::actionButton(
        inputId = 'ab1',
        label = "Need Help?",
        icon = icon("th"),
        onclick = "window.open('https://github.com/Pandora-IsoMemo/CausalR/blob/main/HELP.pdf', '_blank')"
      ),
      shiny::actionButton(
        inputId = 'ab2',
        label = "How to format data before upload",
        icon = icon("th"),
        onclick = "window.open('https://github.com/Pandora-IsoMemo/CausalR/blob/main/HELP.pdf', '_blank')"
      )
    )
  ),
  titlePanel("MPI Causal Impact Dashboard v.001"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Please Upload File"),
      checkboxInput("header", "Header", TRUE),
      checkboxInput("treat_dates", "Treat periods as dates"),
      div(style="display:flex",
        numericInput("min_pre_period", "Minimum Pre-Period Index Value", value = 1),
        numericInput("max_pre_period", "Maximum Pre-Period Index Value", value = 70)
      ),
      div(style="display:flex",
      numericInput("min_post_period", "Minimum Post-Period Index Value", value = 71),
      numericInput("max_post_period", "Maximum Post-Period Index Value", value = 100)
      ),
      conditionalPanel(
        condition = "input.treat_dates",
        div(style="display:flex",
          dateInput("min_pre_period_date", "Min Pre-Period Date", "2014-01-01"),
          dateInput("max_pre_period_date", "Max Pre-Period Date", "2014-03-11")
        ),
        div(style="display:flex",
          dateInput("min_post_period_date", "Min Post-Period Date", "2014-03-12"),
          dateInput("max_post_period_date", "Max Post-Period Date", "2014-04-10")
        )
      ),
      checkboxInput("use_bsts_model", "Use BTST Model as alternative \n (Data should contain no dates)"),
      conditionalPanel(
        condition = "input.use_bsts_model",
        textAreaInput("custom_code_text", "Custom Code:",
                      value = "ss <- AddLocalLevel(list(), y)\nbsts.model <- bsts(y ~ x1, ss, niter = 1000)")
      ),
      actionButton("go", "Model"),
      br(),
      br(),
      tableOutput("table")
    ),
    mainPanel(
      plotOutput("matplot"),
      conditionalPanel(
        condition = "output.matplot",
        div(style="display:flex",
          textInput("title", "Plot Title", ""),
          textInput("x_label", "X Axis Label", ""),
          textInput("y_label", "Y Axis Label", "")
          ),
        downloadButton('downloadpic1', 'Download Plot')
      ),
      plotOutput("cumulative_plot"),
      conditionalPanel(
        condition = "output.cumulative_plot",
        downloadButton('downloadpic2', 'Download Plot')
      ),
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
      df <- subset(df, select = c(y, x1))
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
  
  
  impact_model <- eventReactive(input$go, {
    if (is.null(data())) return(NULL)
    
    if (input$treat_dates) {
      dataTime <- zoo(cbind(data()$y,data()$x1),as.Date(data()$date))
      return(CausalImpact(dataTime, pre_period(), post_period()))
    }
    if (input$use_bsts_model) {

      y <- as.ts(data()$y)
      x1 <- as.ts(data()$x1)
      post.period.response <- y[post_period()[1] : post_period()[2]]
      y[post_period()[1] : post_period()[2]] <- NA
      eval(parse(text = input$custom_code_text))
      #ss <- AddLocalLevel(list(), y)
      #bsts.model <- bsts(y ~ data()$x1, ss, niter = 2000)
      return(CausalImpact(bsts.model = bsts.model,post.period.response = post.period.response))
    }
    return(CausalImpact(data(), pre_period(), post_period()))
  })
  
  output$matplot <- reactive({ 
    renderPlot({
    if (is.null(data())) return(NULL)
    matplot(data(), type = 'l', main = input$title, xlab = input$x_label, ylab = input$y_label)
    })
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
  
  output$downloadpic1 <- downloadHandler(
    filename = "matplot.png",
    content = function(file) {
      png(file)
      matplot(data(), type = 'l', main = input$title, xlab = input$x_label, ylab = input$y_label)
      dev.off()
    })
  
  output$downloadpic2 <- downloadHandler(
    filename = function(){paste("cumulative_plot", '.png', sep = '')},
    content = function(file){
      ggsave(file, plot = plot(impact_model()))
    })
}

shinyApp(ui = ui, server = server)



