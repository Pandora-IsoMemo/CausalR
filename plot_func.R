


# Function to generate the ggplot
generate_datCounterfactual_plot <- function(data, data_line_color, data_line_type, data_line_width,
                                            counter_line_color, counter_line_type, counter_line_width,
                                            counter_evelope_color, counter_evelope_alpha,
                                            show_event, max_pre, min_post, event_line_color, event_line_type,
                                            event_line_width, title_causal, x_causal, y_causal,
                                            title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {
  
  library(zoo)
  mydata <- fortify.zoo(data$series)
  library(ggplot2)
  
  my_plot <- ggplot(mydata, aes(x=Index, y=response)) +
    geom_line(aes(x=Index, y=response, color= data_line_color, linetype = data_line_type, linewidth = data_line_width)) +
    geom_line(aes(x=Index, y=point.pred, color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width
    )) +
    geom_ribbon(aes(ymin=point.pred.lower, ymax=point.pred.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
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





#################
# Function to generate the ggplot
generate_pointwise_plot <- function(data, counter_line_color, counter_line_type, counter_line_width,
                                    counter_evelope_color, counter_evelope_alpha,
                                    show_event, max_pre, min_post, event_line_color, event_line_type,
                                    event_line_width, title_causal, x_causal, y_causal,
                                    title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {
  
  library(zoo)
  mydata <- fortify.zoo(data$series)
  library(ggplot2)
  
  my_plot <- ggplot(mydata, aes(x=Index, y=response)) +
    geom_line(aes(x=Index, y=point.effect, color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width
    )) +
    geom_ribbon(aes(ymin=point.effect.lower, ymax=point.effect.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
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


####################

# Function to generate the ggplot
generate_cumDiff_plot <- function(data, counter_line_color, counter_line_type, counter_line_width,
                                     counter_evelope_color, counter_evelope_alpha,
                                     show_event, max_pre, min_post, event_line_color, event_line_type,
                                     event_line_width, title_causal, x_causal, y_causal,
                                     title_fsize, title_center, xc_sizea, yc_sizea, xc_size, yc_size) {
  
  library(zoo)
  mydata <- fortify.zoo(data$series)
  library(ggplot2)
  
  my_plot <- ggplot(mydata, aes(x=Index, y=response)) +
    geom_line(aes(x=Index, y=cum.effect, color= counter_line_color, linetype = counter_line_type, linewidth = counter_line_width
    )) +
    geom_ribbon(aes(ymin=cum.effect.lower, ymax=cum.effect.upper), color= counter_evelope_color, alpha= counter_evelope_alpha) +
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


