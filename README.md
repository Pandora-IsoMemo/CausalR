# CausalR
![image](https://github.com/user-attachments/assets/4ec4be0b-3634-4ba3-9b15-6ab947d04df6)

`CausalR` is an R-Shiny user-friendly interface for `CausalImpact` R package, which leverages the Bayesian modeling capabilities to estimate the causal effect of an intervention on a time series (Brodersen et al., 2015).  `CausalImpact` is inferred by comparing the counterfactual posterior and the observed data, but users are currently not able to easily navigate to the analysis and visualize the results. Going one step beyond, CausalR is able to generate and visualize a counterfactual prediction, or “what would have happened”, with highly customized features. In addition, `CausalR` introduces a new workflow streamlining the causal analysis by giving users high input data customization, automating model building, and generating informative visualizations. Furthermore, `CausalR` also offers a direct connection to the API of the Pandora data platform, one of the largest archeological databases where various types of time series of data are made available. 

[![Alt Text]<img width="1050" alt="image" src="https://github.com/user-attachments/assets/b352550e-ac6a-444a-b9b4-9e2e9ebe08c2">([link_url](https://isomemoapp.com/app/causalr))


## Installation
Run the following R commands in your R console.
```
options(repos = c(getOption("repos"), PANDORA = "https://Pandora-IsoMemo.github.io/drat/"))
install.packages("CausalR")
```

Or Skip Local Machine Download and access the App on the Web
> ### Web Application
> Access here: https://isomemoapp.com/app/causalr

## Statement of need
In numerous fields such as economics, marketing, historical research, and public health, it's crucial for researchers to understand the causal impacts of interventions for policy-making, decision-making, and risk assessment analysis. An increasingly reliable method for these evaluations is the Bayesian counterfactual analysis of time series data (Landau et al 2022, Liu et al 2022, Kumar et al 2023, Yabe et al 2020). However, there are very few dependable tools for interfacing Bayesian causal analysis and automating the output in a highly sharable platform. 

Introducing `CausalR`, an R-Shiny application that provides a user-friendly interface to address this. Our goal is to broaden the adoption of Bayesian counterfactual analysis across various applications by making it more accessible to those less proficient in R coding. `CausalR` incorporates modules for data import and the import and export of model instances, directly linking up to archeological, radiocarbon, and stable isotopic time series data from the Pandora open data platform.

## Example
Run the following R commands to kick start the app:
```
library(CausalR)
startApplication()
```
Watch the YouTube Video for an example:
- Use this example dataset: 
Installation instructions: Is there a clearly-stated list of dependencies? Ideally these should be handled with an automated package management solution.
? Example usage: Do the authors include examples of how to use the software (ideally to solve real-world analysis problems).

## Tests
Functionality documentation: Is the core functionality of the software documented to a satisfactory level (e.g., API method documentation)?
Automated tests: Are there automated tests or manual steps described so that the functionality of the software can be verified?
Community guidelines: Are there clear guidelines for third parties wishing to 1) Contribute to the software 2) Report issues or problems with the software 3) Seek support
`git pull git@github.com:Pandora-IsoMemo/CausalR.git`

## References

