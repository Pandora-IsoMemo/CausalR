FROM inwt/r-shiny:4.5.1

RUN echo "options(repos = c(getOption('repos'), PANDORA = 'https://Pandora-IsoMemo.github.io/drat/'))" >> /usr/local/lib/R/etc/Rprofile.site

RUN Rscript -e "remotes::install_github(c('r-lib/httr2@v1.2.3', 'tidyverse/ellmer@v0.4.1'))"

COPY . .

RUN installPackage

CMD ["Rscript", "-e", "library(CausalR);startApplication(3838)"]
