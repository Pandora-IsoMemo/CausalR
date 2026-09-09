# Generate the Pointwise plot

Generate the Pointwise plot

## Usage

``` r
generate_pointwise_plot(
  data,
  counter_line_color,
  counter_line_type,
  counter_line_width,
  counter_evelope_color,
  counter_evelope_alpha,
  show_event,
  max_pre,
  min_post,
  event_line_color,
  event_line_type,
  event_line_width,
  title_causal,
  x_causal,
  y_causal,
  title_fsize,
  title_center,
  xc_sizea,
  yc_sizea,
  xc_size,
  yc_size
)
```

## Arguments

- data:

  data frame with the series and the counterfactual

- counter_line_color:

  color of the counterfactual line

- counter_line_type:

  type of the counterfactual line

- counter_line_width:

  width of the counterfactual line

- counter_evelope_color:

  color of the counterfactual envelope

- counter_evelope_alpha:

  alpha of the counterfactual envelope

- show_event:

  boolean to show the event

- max_pre:

  maximum value before the event

- min_post:

  minimum value after the event

- event_line_color:

  color of the event line

- event_line_type:

  type of the event line

- event_line_width:

  width of the event line

- title_causal:

  title of the plot

- x_causal:

  x axis label

- y_causal:

  y axis label

- title_fsize:

  title font size

- title_center:

  title center

- xc_sizea:

  x axis label size

- yc_sizea:

  y axis label size

- xc_size:

  x axis size

- yc_size:

  y axis size

## Value

ggplot
