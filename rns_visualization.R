# rns_visualization.R
#
# contains code for processing and visualizing average characteristics of random semigroups
# generated using generate_rns.sage

library(dplyr)
library(ggplot2)

data1 <- read.csv2("data.txt")
data2 <- read.csv2("data2.txt")

data <- bind_rows(data1, data2)

data$p <- as.double(data$p)

# parses python lists of ints formatted as strings into numeric vectors 
py_list_to_numeric <- function(pylist){
  nums <- strsplit(substr(pylist, start = 2, stop = nchar(pylist) - 1), split = ", ")
  return(as.numeric(unlist(nums)))
}

data$gens <- sapply(data$gens, py_list_to_numeric)

data <- subset(data, select = -c(X))

averages <- data %>%
  group_by(p, m, M) %>%
  summarise(avg_e = mean(e), avg_F = mean(F), avg_g = mean(g), avg_t = mean(t))

# embedding dimension
e_plot <- ggplot(data = averages, aes(x = M)) +
  geom_point(aes(y = avg_e, color = factor(p))) +
  facet_grid(.~m) +
  scale_color_discrete(name = "p") +
  ylab("E[e(S)]")

# Frobenius number
f_plot <- ggplot(data = averages, aes(x = M)) +
  geom_point(aes(y = avg_F, color = factor(p))) +
  facet_grid(.~m) +
  scale_color_discrete(name = "p") +
  ylab("E[F(S)]")

# gaps
g_plot <- ggplot(data = averages, aes(x = M)) +
  geom_point(aes(y = avg_g, color = factor(p))) +
  facet_grid(.~m) +
  scale_color_discrete(name = "p") +
  ylab("E[g(S)]")

# type
t_plot <- ggplot(data = averages, aes(x = M)) +
  geom_point(aes(y = avg_t, color = factor(p))) +
  facet_grid(.~m) +
  scale_color_discrete(name = "p") +
  ylab("E[t(S)]")
