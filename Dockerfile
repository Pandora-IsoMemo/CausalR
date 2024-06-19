# Use base image from our organization
FROM ghcr.io/pandora-isomemo/base-image:latest

ADD . .

# Install the R packages
RUN installPackage

# Run the Shiny app
CMD ["Rscript", "-e", "library(CausalR);startApplication(3838)"]
