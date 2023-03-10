#' Data import module
#'
#' Displays a button which opens a import dialog when clicked
#'
#' @param id id of module
#' @param label label of button
#'
#' @rdname importData
importDataUI <- function(id, label = "Import Data") {
  ns <- NS(id)
  actionButton(ns("openPopup"), label)
}

#' Server function for data import
#'
#' Backend for data import module
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param rowNames (reactive) use this for rownames of imported data
#' @param colNames (reactive) use this for colnames of imported data
#' @param customWarningChecks list of reactive functions which will be executed after importing of data.
#'   functions need to return TRUE if check is successfull or a character with a warning otherwise.
#' @param customErrorChecks list of reactive functions which will be executed after importing of data.
#'   functions need to return TRUE if check is successfull or a character with a warning otherwise.
#'
importData <- function(input, output, session,
                       rowNames = NULL,
                       colNames = NULL,
                       customWarningChecks = list(),
                       customErrorChecks = list()
                       ) {

  ns <- session$ns

  values <- reactiveValues(
    warnings = list(),
    errors = list(),
    fileName = NULL,
    fileImportSuccess = NULL,
    dataImport = NULL,
    data = list()
  )

  observeEvent(input$openPopup, ignoreNULL = TRUE, {
    reset("file")
    values$fileImportWarning <- NULL
    values$fileImportSuccess <- NULL
    values$dataImport <- NULL
    values$data <- list()
    values$headData <- NULL

    showModal(importDataDialog(ns = ns))
  })

  observeEvent(list(
    input$file,
    input$type,
    input$colSep,
    input$decSep,
    input$rownames#,
    #input$includeSd
  ), {
    values$dataImport <- NULL

    inFile <- input$file

    if (is.null(inFile)){
      shinyjs::disable("accept")
      return(NULL)
    }

    values$warnings <- list()
    values$errors <- list()
    values$fileImportSuccess <- NULL

    df <- tryCatch(
      loadData(inFile$datapath, input$type, input$colSep, input$decSep,
               isTRUE(input$rownames)),
      error = function(e){
        values$warnings <- c(values$warnings, "Could not read in file.")
        NULL
      },
      warning = function(w){
        values$warnings <- c(values$warnings, "Could not read in file.")
        NULL
      }
    )

    if (is.null(df)) {
      shinyjs::disable("accept")
      values$headData <- NULL
      return(NULL)
    }

    #attr(df, "includeSd") <- isTRUE(input$includeSd)

    ## set colnames
    if (!is.null(colNames)) {
      colnames(df) <- rep("", ncol(df))
      mini <- min(length(colNames()), ncol(df))
      colnames(df)[seq_len(mini)] <- colNames()[seq_len(mini)]
    }
    ## Import technically successful
    values$fileName <- inFile$name
    values$dataImport <- as.data.frame(df)

    values$headData <- lapply(head(as.data.frame(df)), function(z){
      if(is.character(z)){
        substr(z, 1, 50)
      } else {
        z
      }
    })[1:min(ncol(df), 5)]

    ## Import valid?
    lapply(customWarningChecks, function(fun) {
      res <- fun()(df)
      if (!isTRUE(res)) {
        values$warnings <- c(values$warnings, res)
      }
    })

    lapply(customErrorChecks, function(fun) {
      res <- fun()(df)
      if (!isTRUE(res)) {
        values$errors <- c(values$errors, res)
      }
    })

    if (length(values$errors) > 0){
      shinyjs::disable("accept")
      return(NULL)
    }

    shinyjs::enable("accept")
    values$fileImportSuccess <- "Data import was successful"
  })

  output$warning <- renderUI(tagList(lapply(values$warnings, tags$p)))
  output$error <- renderUI(tagList(lapply(values$errors, tags$p)))
  output$success <- renderText(values$fileImportSuccess)

  output$preview <- renderTable(values$headData, bordered = TRUE,
                                rownames = FALSE, colnames = TRUE)

  observeEvent(input$cancel, {
    removeModal()
  })

  observeEvent(input$accept, {
    removeModal()

    values$data[[values$fileName]] <- values$dataImport
  })

  reactive(values$data)
}

# import data dialog ui
importDataDialog <- function(ns){
  modalDialog(
    useShinyjs(),
    title = "Import Data",
    footer = tagList(
      actionButton(ns("cancel"), "Cancel"),
      actionButton(ns("accept"), "Accept")
    ),
    fileInput(ns("file"), "File"),
    selectInput(
      ns("type"),
      "File type",
      choices = c("xlsx", "csv"),
      selected = "xlsx"
    ),
    conditionalPanel(
      condition = paste0("input.type == 'csv'"),
      div(style = "display: inline-block;horizontal-align:top; width: 80px;",
          textInput(ns("colSep"), "column separator:", value = ",")),
      div(style = "display: inline-block;horizontal-align:top; width: 80px;",
          textInput(ns("decSep"), "decimal separator:", value = ".")),
      ns = ns
    ),
    checkboxInput(ns("rownames"), "First column contains rownames"),
    helpText(
      "The first row in your file need to contain variable names."
    ),
    div(class = "text-warning", uiOutput(ns("warning"))),
    div(class = "text-danger", uiOutput(ns("error"))),
    div(class = "text-success", textOutput(ns("success"))),
    tableOutput(ns("preview"))
  )
}

loadData <- function(file, type, sep = ",", dec = ".", rownames = FALSE) {
  encTry <- as.character(guess_encoding(file)[1,1])
  if(type == "xlsx"){
    xlsSplit <- strsplit(file, split = "\\.")[[1]]
    if(xlsSplit[length(xlsSplit)] == "xls"){
      type <- "xls"
    }
  }
  data <- switch(
    type,
    csv = suppressWarnings({read.csv(file, sep = sep, dec = dec, stringsAsFactors = FALSE, row.names = NULL,
                                     fileEncoding=encTry)}),
    txt = suppressWarnings({read.csv(file, sep = sep, dec = dec, stringsAsFactors = FALSE, row.names = NULL,
                                     fileEncoding=encTry)}),
    xlsx = read.xlsx(file),
    xls = suppressWarnings({readxl::read_excel(file)})
  )

  if (is.null(data)) return(NULL)

  if (is.null(dim(data))) {
    stop("Could not determine dimensions of data")
    return(NULL)
  }

  if (any(dim(data) == 0)) {
    stop("Number of rows or columns equal to 0")
    return(NULL)
  }

  if (rownames) {
    rn <- data[, 1]
    data <- as.matrix(data[, -1, drop = FALSE])
    rownames(data) <- rn
  }

  return(data)
}
