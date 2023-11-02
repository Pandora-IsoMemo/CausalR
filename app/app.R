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
library(stringr)
library(shinythemes)

source("plot_func.R")


ui <- fluidPage(
  
  includeCSS("stylesheet.css"),
  shiny::fluidRow(
    shinydashboard::box(
      shiny::actionButton(
        inputId = 'ab1',
        label = "Need Help?",
        icon = icon("th"),
        onclick = "window.open('https://github.com/Pandora-IsoMemo/CausalR/blob/main/HELP.pdf', '_blank')",
        style="color: #fff; background-color: #006c66; border-color: #2e6da4"
      ),
      shiny::actionButton(
        inputId = 'ab2',
        label = "How to format data before upload",
        icon = icon("th"),
        onclick = "window.open('https://github.com/Pandora-IsoMemo/CausalR/blob/main/HELP.pdf', '_blank')",
        style="color: #fff; background-color: #006c66; border-color: #2e6da4"
      )
    )
  ),
  #theme = shinytheme(theme = "spacelab"), 
  br(),
  navbarPage(theme = shinytheme("flatly"), title= "CausalR v.0.0.1", collapsible = TRUE,
        tags$head(tags$style(HTML('.navbar-static-top {background-color: #006c66;}',
            '.navbar-default .navbar-nav>.active>a {background-color: #006c66;}'))),
       
        ),
                                                         
                                                         
                                                      
                                                         
  
  sidebarLayout(
    sidebarPanel(
      importDataUI('pandora_dat',label = "Import Data"),
      tags$br(), tags$br(),
      importDataUI(("modelUpload"), label = "Import Model"),
      tags$br(), tags$br(),
      downloadModelUI(id = "modelDownload", label = "Download Model"),
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
        # conditionalPanel(
        #   condition = "output.cumulative_plot",
        #   br(),
          selectInput(("plot_option"),
                      "Select Plot Type:", 
                      choices = c("Counterfactual Plot", "Pointwise Plot", "Cumulative Difference Plot"),
                      selected = "Counterfactual Plot"),
          plotOutput(("selected_plot")),
          
          # Add this code inside the conditionalPanel for cumulative_plot
          conditionalPanel(
            condition = "output.cumulative_plot ",
            selectInput("plot_customization", "Plot Customization:",
                        choices = c("Customize counter line", "Customize event line", "Customize labels")),
            
            # Customize counter line input boxes
            conditionalPanel(
              condition = "input.plot_customization == 'Customize counter line'",
              div(style = "display:flex;",
                  textInput("counter_line_color", "Counter Line Color:", value = "blue"),
                  selectInput("counter_line_type", "Counter Line Type:",
                              choices = c("solid", "dashed"), selected = "dashed"),
                  numericInput("counter_line_width", "Counter Line Width:", value = 5),
                  textInput("counter_evelope_color", "Counter Envelope Color:", value = "grey70"),
                  numericInput("counter_evelope_alpha", "Counter Envelope Alpha:", value = 0.2)
              )
            ),
            
            # Customize event line input boxes
            conditionalPanel(
              condition = "input.plot_customization == 'Customize event line'",
              div(style = "display:flex;",
                  textInput("event_line_color", "Event Line Color:", value = "blue"),
                  selectInput("event_line_type", "Event Line Type:",
                              choices = c("solid", "dashed"), selected = "dashed"),
                  numericInput("event_line_width", "Event Line Width:", value = 5)
              )
            ),
            
            # Customize labels input boxes
            conditionalPanel(
              condition = "input.plot_customization == 'Customize labels'",
              div(style = "display:flex;",
                  textInput("title_causal", "Title:"),
                  textInput("x_causal", "X Axis Label:", value = "Time"),
                  textInput("y_causal", "Y Axis Label:"),
                  numericInput("title_fsize", "Title Font Size:", value = 30),
                  numericInput("title_center", "Title Center:", value = 0.5),
                  numericInput("xc_sizea", "X Label Font Size:", value = 15),
                  numericInput("yc_sizea", "Y Label Font Size:", value = 15),
                  numericInput("xc_size", "X Axis Font Size:", value = 30),
                  numericInput("yc_size", "Y Axis Font Size:", value = 30)
              )
            #)
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

  data <- reactiveVal(NULL)
  observe({
    # reset data
    if (length(importedDat()) == 0 ||  is.null(importedDat()[[1]])) data(NULL)

    req(length(importedDat()) > 0, !is.null(importedDat()[[1]]))
    df <- importedDat()[[1]]
    
    # if needed, add any app-specific validation here:
    # valid <- validateImport(df)
    # 
    # if (!valid){
    #   showNotification("Import is not valid.")
    #   data(NULL)
    # } else {
    #   data(df)
    # }
    
    # this is not the best place to prepare data, optimally this is done in a separate function
    # with checks in advance if respective columns do exist in the uploaded data
    if (!is.null(df$x1)) df$x1 <- as.numeric(df$x1)
    if (!is.null(df$y)) df$y <- as.numeric(df$y)
    df[is.na(df)] <- 0
    
    data(df)
  }) %>% bindEvent(importedDat()) 
  
  # Download/Upload Model ----
  modelNotes <- reactiveVal()
  downloadModelServer(id = "modelDownload",
                      dat = data,
                      inputs = input,
                      model = impact_model,
                      rPackageName = "CausalR",
                      fileExtension = "causalr",
                      modelNotes = modelNotes,
                      triggerUpdate = reactive(TRUE))
  
  uploadedModel <- importDataServer("modelUpload",
                                    title = "Import Model",
                                    defaultSource = "file",
                                    ignoreWarnings = TRUE,
                                    importType = "model",
                                    fileExtension = "causalr",
                                    rPackageName = "CausalR")
  
  observe(priority = 100, {
    req(length(uploadedModel()) > 0, uploadedModel()[[1]][["data"]])
    
    ## update data ----
    data(uploadedModel()[[1]][["data"]])
    ## reset and update notes
    modelNotes("")
    modelNotes(uploadedModel()[[1]][["notes"]])
  }) %>%
    bindEvent(uploadedModel())
  
  observe(priority = 50, {
    req(length(uploadedModel()) > 0, uploadedModel()[[1]][["inputs"]])
    
    ## update inputs ----
    uploadedInputs <- uploadedModel()[[1]][["inputs"]]
    inputIDs <- names(uploadedInputs)
    inputIDs <- inputIDs[inputIDs %in% names(input)]
    for (i in 1:length(inputIDs)) {
      session$sendInputMessage(inputIDs[i],  list(value = uploadedInputs[[inputIDs[i]]]) )
    }
    
    ## update model ----
    impact_model(uploadedModel()[[1]][["model"]])
  }) %>%
    bindEvent(uploadedModel())
  
  ####################################################
  
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
  
  # if we want to import model objects than
  # impact_model must be an object that we can update
  impact_model <- reactiveVal(NULL)
  observe({
    # reset impact_model
    impact_model(NULL)
    
    req(impact_model_react())
    impact_model(impact_model_react())
  }) %>% bindEvent(impact_model_react(), ignoreNULL = FALSE)
  
  impact_model_react <- eventReactive(input$go, {
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
      
      # protection against code injection:
      text2 <- str_replace_all(input$custom_code_text,"q()", "")
      text2 <- str_replace_all(text2,fixed("\\"), "")
      text2 <- str_replace_all(text2,"/", "")
      text2 <- str_replace_all(text2,"system", "")
      text2 <- str_replace_all(text2,"rm", "")
      eval(parse(text = text2))
      
      
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
    print(input$counter_line_color)
    print(input$counter_line_type)
    print(input$counter_line_width)
    
    plot1 <- generate_datCounterfactual_plot(data = impact_model(),
                                             data_line_color = "black",  # Replace with input$counter_line_color
                                             data_line_type = "solid",  # Replace with input$counter_line_type
                                             data_line_width = input$counter_line_width,
                                             counter_line_color = input$counter_line_color,
                                             counter_line_type = input$counter_line_type,
                                             counter_line_width = input$counter_line_width,
                                             counter_evelope_color = input$counter_evelope_color,
                                             counter_evelope_alpha = input$counter_evelope_alpha,
                                             show_event = TRUE,
                                             max_pre = input$max_pre_period,
                                             min_post = input$min_post_period,
                                             event_line_color = input$event_line_color,
                                             event_line_type = input$event_line_type,
                                             event_line_width = input$event_line_width,
                                             title_causal = input$title_causal,
                                             x_causal = input$x_causal,
                                             y_causal = input$y_causal,
                                             title_fsize = input$title_fsize,
                                             title_center = input$title_center,
                                             xc_sizea = input$xc_sizea,
                                             yc_sizea = input$yc_sizea,
                                             xc_size = input$xc_size,
                                             yc_size = input$yc_size)
    return(plot1)
  })
  
  
  plot2_obj <- reactive({
    plot2  <- generate_pointwise_plot(data = impact_model(),
                                    counter_line_color = input$counter_line_color,
                                    counter_line_type = input$counter_line_type,
                                    counter_line_width = input$counter_line_width,
                                    counter_evelope_color = input$counter_evelope_color,
                                    counter_evelope_alpha = input$counter_evelope_alpha,
                                    show_event = TRUE,
                                    max_pre = input$max_pre_period,
                                    min_post = input$min_post_period,
                                    event_line_color = input$event_line_color,
                                    event_line_type = input$event_line_type,
                                    event_line_width = input$event_line_width,
                                    title_causal = input$title_causal,
                                    x_causal = input$x_causal,
                                    y_causal = input$y_causal,
                                    title_fsize = input$title_fsize,
                                    title_center = input$title_center,
                                    xc_sizea = input$xc_sizea,
                                    yc_sizea = input$yc_sizea,
                                    xc_size = input$xc_size,
                                    yc_size = input$yc_size
                                    )
    return(plot2)
  })
  
  plot3_obj <- reactive({
    plot3 <- generate_cumDiff_plot(data = impact_model(),
                                   counter_line_color = input$counter_line_color,
                                   counter_line_type = input$counter_line_type,
                                   counter_line_width = input$counter_line_width,
                                   counter_evelope_color = input$counter_evelope_color,
                                   counter_evelope_alpha = input$counter_evelope_alpha,
                                   show_event = TRUE,
                                   max_pre = input$max_pre_period,
                                   min_post = input$min_post_period,
                                   event_line_color = input$event_line_color,
                                   event_line_type = input$event_line_type,
                                   event_line_width = input$event_line_width,
                                   title_causal = input$title_causal,
                                   x_causal = input$x_causal,
                                   y_causal = input$y_causal,
                                   title_fsize = input$title_fsize,
                                   title_center = input$title_center,
                                   xc_sizea = input$xc_sizea,
                                   yc_sizea = input$yc_sizea,
                                   xc_size = input$xc_size,
                                   yc_size = input$yc_size
  
                                )
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



