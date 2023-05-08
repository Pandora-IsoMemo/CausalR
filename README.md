# CausalR
last edit: by Jian May 8, 2023

News: Feb 12:
- Server.R
  > borrow idea from https://github.com/yhejazi/tutorials/blob/main/rshiny/server.R 
  
  > modified the server file {https://github.com/Pandora-IsoMemo/CausalR/blob/feat/inputBox/inst/app/server.R}
  
  > TODO: make sure the function works and Renders the plot to the APP. 

App 2: Detecting events in time series and assessing impact of events
Often we are interested in detecting the timing of an event from the time series data. For instance, the Roman shipwreck example shown previously we see a sharp decline at c. 150 AD. This matches a massive pandemic in the Roman Empire that killed about one third of its population. Conversely, we might be interested in knowing what was the impact of an event like a pandemic or a political decision. The Roman Empire was divided into two parts in the 4th century (East and West) and we would like to know what was the impact of this decision on trade (via the shipwreck proxy).
This app will combine two existing R packages: mcp and CausalImpact
mcp takes a Bayesian approach to point changes. It can detect changes in time series trends following different link functions, it can detect changes in variances, and point change estimates are given as distributions (see example below)

<img width="643" alt="image" src="https://user-images.githubusercontent.com/74462173/216515647-35ead397-d3b5-45b1-9f8d-07648c390e79.png">

The implementation of mcp within the app should follow options given at this website: https://lindeloev.github.io/mcp/index.html
Currently a mcp user has to select a number of functions and their type and point changes. In the example above, we have 3 linear functions and 2 point changes. Different options on these can be compared using leave-one-out cross-validation (loo) implemented within the app. Something to be added is an option where user can select a maximum number of functions, potential function types, max number of change points. A programming cycle is run for all combinations of these (up to max numbers) and their loo calculated. The output will rank models.
The implementation of CausalImpact should follow this vignette: https://google.github.io/CausalImpact/CausalImpact.html
One can quantify the impact of a certain event (e.g., political decision) at a known time under a counterfactual Bayesian approach. This requires the time series that one is interested in (e.g., number of written documents, shipwrecks) and independent time series for comparison. Illustration below.

<img width="643" alt="image" src="https://user-images.githubusercontent.com/74462173/216515694-dda42d29-5043-4c99-a320-b44ba6a01826.png">

The above shows the impact of event at time 70. The blue broad line after is the predicted time series and the think dark line is the actual data. The impact is the difference.
