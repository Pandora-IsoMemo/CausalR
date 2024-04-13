FROM ghcr.io/pandora-isomemo/base-image:latest

RUN adduser --system --disabled-password --home /home/inwt inwt
ENV HOME /home/inwt 
USER inwt

ADD . .

## copy necessary files
## renv.lock file --/Users/johann/Documents/CausalR/
COPY CausalR/renv.lock ./renv.lock
## app folder
COPY CausalR/ ./app

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'library(renv)'
#RUN Rscript -e 'renv::snapshot()'
RUN Rscript -e 'renv::restore()' \


    && installPackage DataTools \
    && installPackage

CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]





