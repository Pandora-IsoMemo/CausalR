


# Function to generate the ggplot
generate_datCounterfactual_plot <- function(data,
                                            data_line_color,
                                            data_line_type,
                                            data_line_width,
                                            counter_line_color,
                                            counter_line_type,
                                            counter_line_width,
                                            counter_evelope_color,
                                            counter_evelope_alpha,
                                            show_event, max_pre, min_post, event_line_color, event_line_type,
                                            event_line_width, title_causal, x_causal, y_causal,
                                            title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {

  mydata <- fortify.zoo(data$series)

  my_plot <- ggplot(mydata, aes(x=.data$Index, y=.data$response)) +
    geom_line(aes(x=.data$Index, y=.data$response), color= data_line_color, linetype = data_line_type, linewidth = data_line_width) +
    geom_line(aes(x=.data$Index, y=.data$point.pred), color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width) +
    scale_color_manual(values = c("response" = 'red', "point.pred" = 'blue')) +
    # scale_color_manual(values = c(
    #   'Y1' = 'darkblue',
    #   'Y2' = 'red')) +
    labs(color = 'Y series') +
    geom_ribbon(aes(ymin=.data$point.pred.lower, ymax=.data$point.pred.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
    labs(title = title_causal, x = x_causal, y= y_causal) +
    theme(plot.title=element_text(size= title_fsize, hjust=title_center),
          axis.text.x = element_text(size = xc_sizea),
          axis.text.y = element_text(size = yc_sizea),
          axis.title.x = element_text(size = xc_size),
          axis.title.y = element_text(size = yc_size))

  if (show_event) {
    my_plot <- my_plot +
      geom_vline(xintercept = max_pre, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +
      geom_vline(xintercept = min_post, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +
      theme(legend.position="none") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  } else {
    my_plot <- my_plot + theme(legend.position="topright") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  }

  return(my_plot)
}




#################
# Function to generate the ggplot
generate_pointwise_plot <- function(data, counter_line_color, counter_line_type, counter_line_width,
                                    counter_evelope_color, counter_evelope_alpha,
                                    show_event, max_pre, min_post, event_line_color, event_line_type,
                                    event_line_width, title_causal, x_causal, y_causal,
                                    title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {

  mydata <- fortify.zoo(data$series)

  my_plot <- ggplot(mydata, aes(x=.data$Index, y=.data$response)) +
    geom_line(aes(x=.data$Index, y=.data$point.effect), color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width) +
    geom_ribbon(aes(ymin=.data$point.effect.lower, ymax=.data$point.effect.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
    labs(title = title_causal, x = x_causal, y= y_causal) +
    theme(plot.title=element_text(size= title_fsize, hjust=title_center),
          axis.text.x = element_text(size = xc_sizea),
          axis.text.y = element_text(size = yc_sizea),
          axis.title.x = element_text(size = xc_size),
          axis.title.y = element_text(size = yc_size))

  if (show_event) {
    my_plot <- my_plot +
      geom_vline(xintercept = max_pre, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +
      geom_vline(xintercept = min_post, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +

      theme(legend.position="none") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  } else {
    my_plot <- my_plot + theme(legend.position="none") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  }

  return(my_plot)
}


####################

# Function to generate the ggplot
generate_cumDiff_plot <- function(data, counter_line_color, counter_line_type, counter_line_width,
                                  counter_evelope_color, counter_evelope_alpha,
                                  show_event, max_pre, min_post, event_line_color, event_line_type,
                                  event_line_width, title_causal, x_causal, y_causal,
                                  title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {

  mydata <- fortify.zoo(data$series)

  my_plot <- ggplot(mydata, aes(x=.data$Index, y=.data$response)) +
    geom_line(aes(x=.data$Index, y=.data$cum.effect), color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width) +
    geom_ribbon(aes(ymin=.data$cum.effect.lower, ymax=.data$cum.effect.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
    labs(title = title_causal, x = x_causal, y= y_causal) +
    theme(plot.title=element_text(size= title_fsize, hjust=title_center),
          axis.text.x = element_text(size = xc_sizea),
          axis.text.y = element_text(size = yc_sizea),
          axis.title.x = element_text(size = xc_size),
          axis.title.y = element_text(size = yc_size))

  if (show_event) {
    my_plot <- my_plot + geom_vline(xintercept = max_pre, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +
      geom_vline(xintercept = min_post, linetype= event_line_type, color = event_line_color, linewidth= event_line_width) +
      theme(legend.position="none") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  } else {
    my_plot <- my_plot + theme(legend.position="none") +
      theme(panel.background = element_rect(fill = "white", color = "black"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "gray"),
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "gray"))
  }

  return(my_plot)
}


