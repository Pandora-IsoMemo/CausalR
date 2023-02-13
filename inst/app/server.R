#library("PlotR")
library("shiny")
library("CausalImpact")
function (input, output, session) {
  loadedFiles <- callModule(uploadFiles, "files")
  #savedPlots <- callModule(runModel, "model", loadedFiles = loadedFiles)
  # callModule(postProcessing, "post", savedData = savedPlots)
  # callModule(stylePlot, "style", savedData = savedPlots)
  # callModule(addMorePoints, "addPoints", savedData = savedPlots)
  # callModule(downUploads, "downUpload", savedData = savedPlots,
  #            loadedFiles = loadedFiles)
  # callModule(multiplePlots, "multiple", savedData = savedPlots)
  # callModule(multiplePredictions, "multiplePreds", savedData = savedPlots,
  #            loadedFiles = loadedFiles)
  set.seed(1)
  x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
  y <- 1.2 * x1 + rnorm(100)
  y[71:100] <- y[71:100] + 10
  data <- cbind(y, x1)
  matplot(data, type = "l")
  
  output$plot <- renderPlot({
    matplot(data, type = "l")
    # sort by class
    # characters$Character <- factor(characters$Character, 
    #                                levels = characters$Character[order(characters$Class)])
    # 
    # ggplot(data=characters, aes_string(x='Character', y=input$y_var, fill="Class")) +
    #   geom_bar(stat="identity", width=0.8) +
    #   labs(x="Character", y=input$y_var) + coord_flip()
    
  })
}
