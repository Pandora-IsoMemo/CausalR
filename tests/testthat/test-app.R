# Load testthat package
library(testthat)

# Load necessary functions and libraries
library(shiny)
library(CausalImpact)
library(ggplot2)
library(CausalR)

# Test for pre and post period setup
test_that("Pre and post periods are set correctly", {
  # Create a test input for date selection
  input <- list(min_pre_period = 1,
                max_pre_period = 70,
                min_post_period = 71,
                max_post_period = 100,
                treat_dates = FALSE)

  pre_period <- c(input$min_pre_period, input$max_pre_period)
  post_period <- c(input$min_post_period, input$max_post_period)

  expect_equal(length(pre_period), 2)
  expect_equal(pre_period, c(1, 70))

  expect_equal(length(post_period), 2)
  expect_equal(post_period, c(71, 100))
})

# Test for CausalImpact model generation
test_that("CausalImpact model runs without errors", {
  # Create a test dataset
  test_data <- data.frame(date = seq(as.Date("2020-01-01"), as.Date("2020-01-100"), by="day"),
                          x1 = rnorm(100),
                          y = rnorm(100))

  # Set up pre and post period
  pre_period <- c(1, 70)
  post_period <- c(71, 100)

  # Test that CausalImpact runs without errors
  impact_model <- CausalImpact(test_data[, c("y", "x1")], pre_period, post_period)

  expect_s3_class(impact_model, "CausalImpact") # Check if the object is of class 'CausalImpact'
  expect_false(is.null(impact_model)) # Check that the model is not NULL
  expect_gt(length(impact_model$summary), 0) # Check that summary output exists
})

# Test for plot generation
test_that("Plot generation works correctly", {
  # Create a test dataset
  test_data <- data.frame(date = seq(as.Date("2020-01-01"), as.Date("2020-01-10"), by="day"),
                          x1 = rnorm(100),
                          y = rnorm(100))

  # Set up pre and post period
  pre_period <- c(1, 70)
  post_period <- c(71, 100)

  # Run CausalImpact model
  impact_model <- CausalImpact(test_data[, c("y", "x1")], pre_period, post_period)

  # Test matplot generation
  p <- suppressWarnings(matplot(test_data, type = 'l', main = "Test Title", xlab = "Time", ylab = "Y-Value"))
  expect_error(suppressWarnings(matplot(test_data, type = 'l')), NA)

  # Test CausalImpact plot generation
  p2 <- plot(impact_model)
  expect_error(suppressWarnings(plot(impact_model)), NA)
})

# Test for plot customization
test_that("Plot customization options are applied correctly", {
  # Check customization options for counter line
  input <- list(counter_line_color = "blue",
                counter_line_type = "solid",
                counter_line_width = 2)

  plot_customization <- function() {
    ggplot() +
      geom_line(aes(y = c(1, 2, 3), x = c(1, 2, 3)), color = input$counter_line_color, linetype = input$counter_line_type, size = input$counter_line_width)
  }

  p <- plot_customization()

  expect_s3_class(p, "gg") # Check if the plot is a ggplot object
  expect_equal(p$layers[[1]]$aes_params$colour, "blue") # Check if color is applied correctly
  expect_equal(p$layers[[1]]$aes_params$linetype, "solid") # Check if linetype is applied correctly
  expect_equal(p$layers[[1]]$aes_params$size, 2) # Check if line width is applied correctly
})

# Test for downloading plot functionality
test_that("Download plot functionality works", {
  # Use a temporary file for testing download functionality
  temp_file <- tempfile(fileext = ".png")

  # Simulate plot download
  p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
  ggsave(temp_file, plot = p, device = "png")

  expect_true(file.exists(temp_file)) # Check if file is created
  expect_equal(tools::file_ext(temp_file), "png") # Check if the file extension is correct

  # Clean up the temporary file
  unlink(temp_file)
})
