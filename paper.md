---
title: 'CausalR: A R-Shiny Application for Assessing Causal Impact in Time Series Data'
tags:
  - R
  - Time Series Analysis
  - Bayesian Methods
  - Counterfactual Analysis
authors:
  - name: Jianyin Roachell
    orcid: 0000-0003-4846-7251
    corresponding: true
    affiliation: "1" # (Multiple affiliations must be quoted)
  - name: Ricardo Fernandes
    orcid: 0000-0003-2258-3262
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: "1,2,3"


affiliations:
 - name: Max Plank Institute of Geoanthropology, Jena, Germany
   index: 1
 - name: Faculty of Arts, Masaryk University, Brno, Czechia
   index: 2
 - name: Climate Change and History Research Initiative, Princeton University, Princeton, USA
   index: 3
date: 30 September 2024
bibliography: paper.bib

---

# Summary

`CausalR` is an R-Shiny user-friendly interface for CausalImpact` R package, which leverages the Bayesian modeling capabilities to estimate the causal effect of an intervention on a time series (Brodersen et al., 2015).  CausalImpact is inferred by comparing the counterfactual posterior and the observed data, but users are currently not able to easily navigate to the analysis and visualize the results. Going one step beyond, CausalR is able to generate and visualize a counterfactual prediction, or “what would have happened”, with highly customized features. In addition, CausalR introduces a new workflow streamlining the causal analysis by giving users high input data customization, automating model building, and generating informative visualizations. Furthermore, CausalR also offers a direct connection to the API of the Pandora data platform, one of the largest archeological databases where various types of time series of data are made available. 

# Statement of need

In numerous fields such as economics, marketing, historical research, and public health, it's crucial to understand the causal effects of events and interventions for policy-making, decision-making, and risk assessment analysis. This involves evaluating how interventions have impacted key variables over time. An increasingly reliable method for these evaluations is the Bayesian counterfactual analysis of time series data (Landau et al 2022, Liu et al 2022, Kumar et al 2023, Yabe et al 2020).

Even though CausalImpact provides an innovative technique to assess causal impact, it lacks a few user-friendly features. CausalImpact R package employs Bayesian structural time-series (BSTS) modelling to capture the contributions from multiple components, including regression components for contemporaneous covariates, towards a target time series   (Scott & Varian, 2014). Although the impact can be visualized via point wise and cumulative view, it still lacks customizable visualizations. 

We introduce CausalR, an R-Shiny application that provides a user-friendly interface to address the gaps in CausalImpact. Our goal is to broaden the adoption of Bayesian counterfactual analysis across various applications by making it more accessible to those less proficient in R coding. CausalR incorporates modules for data import and the import and export of model instances, directly linking up to archeological, radiocarbon, and stable isotopic time series data from the Pandora open data platform. Users can import data from different data sources from Bronze Age to Iron Age in regional databases. The seamless data integration is one of the more significant features of CausalR. In addition, another noteworthy feature is import and export model instances, which can be stored at Pandora or other online repositories. This facilitates easy access to the models users built and promotes collaborative research projects, so that other researchers can enhance reusability and test repeatability.

# Overview


Figure 1 shows the general CausalR workflow.

### Step 1: Data Upload and Configuration
Users may load time series data in a CSV or Excel format. The first column of the file is the predictor, and the remainder are the covariates. Users may include the time sequence in a date format as the first column. Users can upload local files, using URL file pointers, and directly from the Pandora data platform (https://pandoradata.earth/).   A graph is shown representing the target and covariate time series . Available via the interface are help files on interface use.


Figure 2. CausalR interface shows the data time range selection options and the graph of an imported time series.

### Step 2: Pre- and Post-Period Specification
Users identify the time ranges corresponding to the periods before and after the event or intervention under study. Moreover, users provide date or index values, with the latter corresponding to time series row numbers when dates are absent as a first column.

### Step 3: Model Selection and Execution
By default, the CausalImpact model lacks a local linear trend component. As an alternative, users may choose to input their own code into a custom textbox to render the  Bayesian Structural Time Series (BSTS) model  . Following model selection or customization, the code is then run. In addition, to ensure the security of the software, the custom code functionality is isolated from the main operation system console to prevent malicious code injections. 

### Step 4: Results Visualization and Analysis Report 
CausalR includes three customizable graph outputs:  1) plot of target time series data vs. counterfactual prediction; 2) plot of pointwise difference between data and counterfactual; 3) cumulative difference between data and counterfactual.  Users can export the plot values in a table format. A text report is also displayed, consisting of summary statistics for the post-intervention period and a descriptive interpretation of the results as issued by CausalImpact. Any R errors are also displayed in the text report..

# Usage and Downloading: 
•	CausalR can be installed locally by downloading the package from its GitHub repository (https://github.com/Pandora-IsoMemo/CausalR). 
•	Installation instructions, including instructions in video format, are available at the repository. Users can also employ a Docker container file for local installations that removes the need to install R or any dependencies (https://github.com/Pandora-IsoMemo/CausalR). 
•	Online user-friendly interface for CausalR is also available here: https://isomemoapp.com/app/causalr. Users can save and share model instances. When these are deposited at Pandora, they can be directly loaded from CausalR.


# Conclusion:
CausalR represents a significant advancement in making Bayesian counterfactual analysis more accessible and user-friendly. By addressing the limitations of the CausalImpact package, CausalR improves the user experience with customizable features, streamlined workflows, and seamless data integration with open data platforms like Pandora. These improvements make it easier for researchers across various fields to conduct sophisticated causal impact evaluations regardless of coding expertise. Additionally, its ability to import, export, and store models fosters collaboration and reusability for scholars and researchers in their workflow.  CausalR is a powerful tool for individual analysis and a catalyst for broader scientific inquiry and collaboration.

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"


# Acknowledgements

We acknowledge contributions from INWT of this project.

# References
