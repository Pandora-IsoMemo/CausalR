# CausalR

The app CausalR is based on the CausalImpact package. It models the impact of events on historical trajectories. For instance, how did the economy evolved following a certain political decision. There is a vignette with more details here: https://google.github.io/CausalImpact/CausalImpact.html

Inputs
User uploads an Excel or CSV file with numeric data (data). First row are column names. See point 2 in the vignette describing how to format the data using cbind. 
Input boxes for pre-period ranges (min_pre and max_pre). You will concatenate these inputs so that you have a string looking like this “c(min_pre, max_pre)” and this is saved in pre.period. There should be an option (as a checkbox) to treat the string as a date (using as.Date applied to the concatenated string). If this is chosen it applied to both the pre and post period described below.
Input boxes for post-period ranges (min_post and max_post). You will concatenate these inputs so that you have a string looking like this “c(min_post, max_post)” and this is saved in post.period
Additional model options to be concatenated into a string. Each of the following, if used, should be concatenated into a string saved under model.args. Example: model.args = list(nseasons = 7, season.duration = 24
Numeric input box for niter
TRUE or FALSE option for standardize.data
Numeric input box for prior.level.sd
Numeric input box for nseasons
TRUE or FALSE option for dynamic.regression


Outputs
Simple plot of data: matplot(data, type = "l")
Analysis results. First you run (model.args to be used only if default values are changed. That is user provides inputs for additional model options):
impact <- CausalImpact(data, pre.period, post.period, model.args=list(…))
plot(impact)
Summary text table by running summary(impact) for low precision results or impact$summary for higher precision. A third option includes guidance on interpretation: summary(impact, "report")
There should be a text output where any errors are listed. Remember that you are not expected to debug if the user enters inappropriate data

Missing (can be done later)
Custom model, graphical options, save/load files, Docker file
