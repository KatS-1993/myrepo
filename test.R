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

library(dagitty)
library(ggdag)
library(ggplot2)
library(Rcpp)

# plot dags
dag <- dagitty("dag{y <- z -> x}")
tidy_dagitty(dag)
dagified <-dagify(x~z,y~z,exposure="x",outcome="y")
tidy_dag <- tidy_dagitty(dagified)
str(tidy_dag)
ggdag(dag,layout="circle")

bigger_dag <-dagify(y~x+a+b,
                    x~a+b,
                    exposure="x",
                    outcome="y")
dag_paths(bigger_dag)

ggdag_paths(bigger_dag)

ggdag_parents(bigger_dag,"x")