# author: kathrin schulze
# task: create dags
# date created: 2022-08-02
# last changed: 2022-08-02

# if not previously installed, install the following packages
# otherwise: just load them
dag_packages <- c("dagitty","ggdag","ggplot2","Rcpp")

for (i in 1:length(dag_packages)) {
  
  install.packages(dag_packages[[i]])
  
}

library(tidyverse)
library(dagitty)
library(ggdag)
library(ggplot2)
library(Rcpp)


#set appropriate theme 
theme_set(theme_dag())

# set coordinates
coords_dag <-list(x =c(ES_lag = 0, ES = 1, PS = 1.5, Y = 2), 
                  y =c(ES_lag = 0, ES = 0, PS = 0.2, Y = 0))

#set dag
fem_lab_dag <- dagify(Y ~ ES, 
                      ES~ES_lag, 
                      PS~ES,
                      PS~Y,
                      labels = c("Y" = "Female\nLabor\nSupply",
                                 "ES" = "Elderly\nShare",
                                 "ES_lag" = "Lagged\nElderly\nShare",
                                 "PS"= "Female\nPart-Time\nShare"),
                      outcome="Y",
                      exposure="ES",
                      latent= c("ES_lag"),
                      coords = coords_dag)

# add node status
fem_lab_dag_tidy <- tidy_dagitty(fem_lab_dag) %>%
  node_status()

# set status colors
status_colors <- c(exposure = "#A50F15", outcome = "#006D2C", latent = "grey50")

# simple dag
ggdag(fem_lab_dag, text = FALSE, use_labels = "label",label_size = 3)

## dag with labels
ggplot(fem_lab_dag_tidy, aes(x=x, y=y, xend = xend, yend = yend)) + 
  geom_dag_point(aes(color=status)) + 
  geom_dag_edges() +
  geom_dag_label_repel(aes(label=label, fill=status),
                       fontface= "bold", col = "white", 
                       size= 4, show.legend = FALSE, seed = 1234) +
  geom_dag_edges_link() +
  scale_color_manual(values = status_colors, na.value ="grey20") +
  scale_fill_manual(values = status_colors, na.value ="grey20") +
  guides(color=FALSE, fill = FALSE) +
  theme_dag()

path = getwd()

ggsave(filename = file.path(path,"graphs","part_time_dag1.png"), width = 9, height=4)


## dag without points
ggplot(fem_lab_dag_tidy, aes(x=x, y=y, xend = xend, yend = yend)) + 
  #geom_dag_point(aes(color=status)) + 
  geom_dag_edges() +
  geom_dag_edges_link() +
  geom_dag_text(aes(label =label, color=status)) +
  scale_color_manual(values = status_colors, na.value ="grey20") +
  scale_fill_manual(values = status_colors, na.value ="grey20") +
  guides(color=FALSE, fill = FALSE) +
  theme_dag()

ggsave(filename = file.path(path,"graphs","part_time_dag2.png"), width = 9, height=4)


