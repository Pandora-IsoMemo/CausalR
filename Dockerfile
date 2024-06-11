# Use base image from our organization
FROM ghcr.io/r-shiny:4.2.3

ADD . .

# Install the R packages
RUN installPackage

# Run the Shiny app
CMD ["Rscript", "-e", "library(CausalR);startApplication(3838)"]
