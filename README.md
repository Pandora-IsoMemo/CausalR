# CausalR
![image](https://github.com/user-attachments/assets/4ec4be0b-3634-4ba3-9b15-6ab947d04df6)

Last Updated: Oct 16, 2024

`CausalR` is an R-Shiny user-friendly interface for `CausalImpact` R package, which leverages the Bayesian modeling capabilities to estimate the causal effect of an intervention on a time series (Brodersen et al., 2015).  `CausalImpact` is inferred by comparing the counterfactual posterior and the observed data, but users are currently not able to easily navigate to the analysis and visualize the results. Going one step beyond, CausalR is able to generate and visualize a counterfactual prediction, or “what would have happened”, with highly customized features. In addition, `CausalR` introduces a new workflow streamlining the causal analysis by giving users high input data customization, automating model building, and generating informative visualizations. Furthermore, `CausalR` also offers a direct connection to the API of the Pandora data platform, one of the largest archeological databases where various types of time series of data are made available. 

[![Alt Text]<img width="1050" alt="image" src="https://github.com/user-attachments/assets/b352550e-ac6a-444a-b9b4-9e2e9ebe08c2">([link_url](https://isomemoapp.com/app/causalr))

## Web Application (Recommended)
> Access here: https://isomemoapp.com/app/causalr

## Installation locally
### Method 1) Run the following R commands in your R console.
```
options(repos = c(getOption("repos"), PANDORA = "https://Pandora-IsoMemo.github.io/drat/"))
install.packages("DataTools")
install.packages("CausalR")

library(CausalR)
startApplication()
```
### Method 2) Docker Container Image
1. Install the software Docker
Download installation files from one of the links below and follow installation instructions:

- [Windows](https://docs.docker.com/desktop/install/windows-install/)
- [MacOS](https://docs.docker.com/desktop/install/mac-install/)
- [Linux](https://docs.docker.com/desktop/install/linux/)


2. Download and install docker image of the app
This image contains all elements necessary for you to run the app from a web browser. Run this code in a local terminal

Open a terminal (command line):

Windows command line:
Open the Start menu or press the Windows key + R;
Type cmd or cmd.exe in the Run command box;
Press Enter.
MacOS: open the Terminal app.
Linux: most Linux systems use the same default keyboard shortcut to start the command line: Ctrl-Alt-T or Super-T
Copy paste the text below into the terminal and press Enter:
> `docker pull ghcr.io/pandora-isomemo/causalr:main`

> FOR MacOS M1 edition: `docker pull --platform linux/amd64 ghcr.io/pandora-isomemo/causalr:main`

3. Run the application in Docker
Steps 1 and 2 install the app. To run the app at any time after the installation open a terminal (as described in point 2) copy paste the text below into the terminal and press Enter. Wait for a notification that the app is in “listening” mode.

`docker run -p 3838:3838 ghcr.io/pandora-isomemo/causalr:main`

If the app is shutdown on Docker or if the terminal is closed the app will no longer work in your web browser (see point 4).

4. Display the app in a web browser
Once the app is running in Docker you need to display it in a web browser. For this, copy-paste the address below into your web browser’s address input and press Enter.

`http://127.0.0.1:3838/`

Refer to our Application Main Page for more details: https://pandora-isomemo.github.io/docs/apps.html#download-and-install-docker-image-of-the-app-3

## Statement of need
In numerous fields such as economics, marketing, historical research, and public health, it's crucial for researchers to understand the causal impacts of interventions for policy-making, decision-making, and risk assessment analysis. An increasingly reliable method for these evaluations is the Bayesian counterfactual analysis of time series data (Landau et al 2022, Liu et al 2022, Kumar et al 2023, Yabe et al 2020). However, there are very few dependable tools for interfacing Bayesian causal analysis and automating the output in a highly sharable platform. 

Introducing `CausalR`, an R-Shiny application that provides a user-friendly interface to address this. Our goal is to broaden the adoption of Bayesian counterfactual analysis across various applications by making it more accessible to those less proficient in R coding. `CausalR` incorporates modules for data import and the import and export of model instances, directly linking up to archeological, radiocarbon, and stable isotopic time series data from the Pandora open data platform.

## Example
Run the following R commands to kick start the app:
```
library(CausalR)
startApplication()
```

- Use this example dataset: https://github.com/Pandora-IsoMemo/CausalR/blob/main/causaImp_example_df%20copy.csv

