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
library(DataTools)
library(svglite)

source("plot_func.R")

# source: https://github.com/Pandora-IsoMemo/iso-app/blob/f7366c574c919bde7430616f00b6cc83980fad23/R/03-modelResults2D.R#L974-L992
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
  titlePanel("CausalR v.0.01"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Please Upload File"),
      ##############
      tags$br(), tags$br(),
      importDataUI('pandora_dat',label = "Import Data"),
      tags$br(), tags$br(),
      importDataUI(("modelUpload"), label = "Import Model"),
      tags$br(), tags$br(),
      downloadModelUI(("modelDownload"), NULL),
      
      downUploadButtonUI(("downUpload"), title = "Load a Model", label = "Upload / Download"),
      ##############
      
      
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
      checkboxInput("use_bsts_model", "Use BTST Model as alternative \n (BTST handles date format as integers)"),
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
          textInput("title", "Plot Title", "title"),
          textInput("x_label", "X Axis Label", "time"),
          textInput("y_label", "Y Axis Label", "y-value")
          ),
        downloadButton('downloadpic1', 'Download Plot')
      ),
      plotOutput("cumulative_plot"),
      br(),
      conditionalPanel(
        condition = "output.cumulative_plot",
        downloadButton('downloadpic2', 'Download Plot'),
        
        ### UI for pick 3 from plots ####
        conditionalPanel(
          condition = "output.cumulative_plot",
          br(),
          selectInput(("plot_option"),
                      "Select Plot Type:", 
                      choices = c("Counterfactual Plot", "Pointwise Plot", "Cumulative Difference Plot"),
                      selected = "Counterfactual Plot"),
          plotOutput(("selected_plot")),
          div(style="display:flex",
              numericInput("data_line_width_input", "Data Line Width", value = 5),
              textInput("data_line_color_input", "Data Line Color", value = "red"),
              selectInput("data_line_type_input", "Data Line Type", choices = c("solid", "dashed"))
          ),

          selectInput(("export_format"), "Select Export Format:",
                      choices = c(".PNG", ".PDF", ".JPEG", ".TIFF", ".SVG")),
          
          downloadButton('downloadpic3', 'Download Plot')
        )
        
        
      ),
      br(),
      verbatimTextOutput("results")
      #TODO: HAVE BUTTON FOR DOWNLOAD TEXT OUTPUT: download as TXT file.
    )
  )
)

server <- function(input, output, session) {
  ## Import Data ----
  
  importedDat <- importDataServer("pandora_dat")
  
  fileImport <- reactiveVal(NULL)
  observe({
    # reset model
    
    if (length(importedDat()) == 0 ||  is.null(importedDat()[[1]])) fileImport(NULL)
    
    req(length(importedDat()) > 0, !is.null(importedDat()[[1]]))
    data <- importedDat()[[1]]
    #valid <- validateImport(data, showModal = TRUE)
    
    # if (!valid){
    #   showNotification("Import is not valid.")
    #   fileImport(NULL)
    # } else {
    #   fileImport(data)
    # }
    fileImport(data)
  }) %>% bindEvent(importedDat())
  
  #print(data())
  
  # Download/Upload Model ----
  #uploadedNotes <- reactiveVal()
  # callModule(downloadModel, "modelDownload", session = session,
  #            values = values, 
  #            model = model,
  #            uploadedNotes = uploadedNotes)
  # 
  # uploadedValues <- importDataServer("modelUpload",
  #                                    title = "Import Model",
  #                                    defaultSource = "file",
  #                                    importType = "model",
  #                                    rPackageName = "ReSources",
  #                                    ignoreWarnings = TRUE)
  
  #observeEvent(uploadedValues(), {
  # MODEL DOWN- / UPLOAD ----
  uploadedData <- downUploadButtonServer(
    "downUpload",
    dat = data,
    inputs = input,
    model = Model,
    rPackageName = "MpiIsoApp",
    githubRepo = "iso-app",
    subFolder = "AverageR",
    helpHTML = getHelp(id = "model2D"),
    modelNotes = reactive(input$modelNotes),
    compressionLevel = 1)
  
  observe(priority = 100, {
    # reset model
    Model(NULL)
    
    ## update data ----
    # updating isoData could influence the update of isoData in other modelling tabs ... !
    # First check if desired! If ok, than:
    # if (uploadedData$inputs$dataSource == "file") {
    #   fileImport(uploadedData$data)
    # } else {
    #   isoData(uploadedData$data)
    # }
    
    data(uploadedData$data)
  }) %>%
    bindEvent(uploadedData$data)
  
  ########################################################
  observe(priority = 50, {
    ## reset input of model notes
    updateTextAreaInput(session, "modelNotes", value = "")
    
    ## update inputs ----
    inputIDs <- names(uploadedData$inputs)
    inputIDs <- inputIDs[inputIDs %in% names(input)]
    
    for (i in 1:length(inputIDs)) {
      session$sendInputMessage(inputIDs[i],  list(value = uploadedData$inputs[[inputIDs[i]]]) )
    }
  }) %>%
    bindEvent(uploadedData$inputs)
  
  observe(priority = 10, {
    ## update model ----
    Model(uploadedData$model)
  }) %>%
    bindEvent(uploadedData$model)
  ####################################################
  
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
  
  output$matplot <- renderPlot({
    if (is.null(data())) return(NULL)
    matplot(data(), type = 'l', main = input$title, xlab = input$x_label, ylab = input$y_label)
    legend("topleft", colnames(data()),col=seq_len(ncol(data())),cex=0.8,fill=seq_len(ncol(data())))
    })

  
  output$cumulative_plot <- renderPlot({
    if (is.null(impact_model())) return(NULL)
    plot(impact_model())
  })
  
  
  plot1_obj <- reactive({
    plot1 <- generate_datCounterfactual_plot(data = impact_model(),
                                          data_line_color = "red", data_line_type = "solid", data_line_width = 5,
                                          counter_line_color = "blue", counter_line_type = "dashed", counter_line_width = 5,
                                          counter_evelope_color = "grey70", counter_evelope_alpha = 0.2,
                                          show_event = TRUE, position_event = 40,
                                          event_line_color = "blue", event_line_type = "dashed", event_line_width = 5,
                                          title_causal = "Data vs. counterfactual", x_causal = "Time", y_causal = "Data & counterfactual",
                                          title_fsize = 30, title_center = 0.5, xc_sizea = 15, yc_sizea = 15, xc_size = 30, yc_size = 30)
  return(plot1)
    })
  
  plot2_obj <- reactive({
    plot2  <- generate_pointwise_plot(data = impact_model(),
                                    counter_line_color = "blue",
                                    counter_line_type = "dashed",
                                    counter_line_width = 5,
                                    counter_evelope_color = "grey70",
                                    counter_evelope_alpha = 0.2,
                                    show_event = TRUE,
                                    position_event = 40,
                                    event_line_color = "blue",
                                    event_line_type = "dashed",
                                    event_line_width = 5,
                                    title_causal = "Pointwise difference",
                                    x_causal = "Time",
                                    y_causal = "Pointwise difference",
                                    title_fsize = 30, title_center = 0.5, xc_sizea = 15, yc_sizea = 15, xc_size = 30, yc_size = 30)
    return(plot2)
  })
  
  plot3_obj <- reactive({
    plot3 <- generate_cumDiff_plot(data = impact_model(),
                                counter_line_color = "blue",
                                counter_line_type = "dashed",
                                counter_line_width = 5,
                                counter_evelope_color = "grey70",
                                counter_evelope_alpha = 0.2,
                                show_event = TRUE,
                                position_event = 40,
                                event_line_color = "blue", event_line_type = "dashed", event_line_width = 5,
                                title_causal = "Cumulative Difference", x_causal = "Time", y_causal = "Cumulative difference",
                                title_fsize = 30, title_center = 0.5, xc_sizea = 15, yc_sizea = 15, xc_size = 30, yc_size = 30)
  return(plot3)
  })
  
  
  
  final_plot <- reactive({
    if (is.null(impact_model())) return(NULL)
    
    selected_option <- input$plot_option
    plot <- NULL
    
    if (selected_option == "Counterfactual Plot") {
      # Generate ggplot for option1'
      return(plot1_obj())
    } else if (selected_option == "Pointwise Plot") {
      # Generate ggplot for option2
      return(plot2_obj())
    } else if (selected_option == "Cumulative Difference Plot") {
      # Generate ggplot for option3
      return(plot3_obj())
    }
    
  })
  
  output$selected_plot <- renderPlot({
    return(final_plot())
    })
  
  # observeEvent(input$downloadpic3, {
  #   if (is.null(impact_model())) return(NULL)
  #format_select <- callModule(format_select_mod_server, "format")
  
  output$downloadpic3 <- downloadHandler(
       filename = function(){paste(input$plot_option, input$export_format, sep = '')},
       content = function(file){
         ggsave(file, final_plot())}
)
  
  
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



