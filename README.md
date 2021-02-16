# Capacitated Vehicle Routing Problem with Time Windows (CVTPTW) calculated with Genetic Algorithm (GA) and visualise in Indonesia Interactive Maps (ggplots &amp; ggiraph)

![alt text](https://img.shields.io/badge/Language-R-brightgreen) ![alt text](https://img.shields.io/badge/Author-Fauzan%20Rahman-blue)

## Package
```
This is the following library that need to be run in R Console.
install.packages(“tidyverse”)
install.packages(“ggrepel”)
install.packages(“GA”)
install.packages(“doParallel”)
install.packages(“tictoc”)
install.packages(“readxl”)
install.packages(“writexl”)
install.packages(“indonesia”)
install.packages(“ggiraph”)
Note : doParallel is only required for large scale route determination.
```

Program Overview 

![alt text](https://user-images.githubusercontent.com/78789134/107484343-debac700-6bb4-11eb-99b1-4763bb52db49.JPG)

## Preface 

Distribution is an activity to transfer goods from the supplier to the agent in a supply chain. Distribution is key to the profits that the company will earn because the distribution will directly affect the cost of the supply chain and the needs of the agent. The right distribution network can be used to achieve a wide range of objectives from supply chains, ranging from low cost to high response to agent demand 

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107484038-72d85e80-6bb4-11eb-95ee-e6609cf726e0.JPG" />
</p>

## Overview 

Planning the distribution process which is important so that companies can deliver products to consumers on time, in the right place, and good condition. The distribution of products from source to several destinations is certainly a fairly complex problem because the existence of several places of destination for product delivery will cause several distribution lines that are longer travel times. Poor distribution system planning will lead to wasteful transportation costs.

It is necessary to design a more optimal distribution route by considering the shortest distance, maximum capacity of the vehicle, and the working hours of the driver to  minimize the total distribution time and save the company expenses. In addition, lateness in the delivery of products is feared to decrease customer satisfaction. With the design of distribution routes, it is expected that products can be distributed to customers more quickly and optimally.

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107481887-7ae2cf00-6bb1-11eb-9b8a-3694cfbc7ac7.png" />
</p>

## Genetic Algorithm

Algorithm development carried out is the development of the Nearest Neighbor algorithm as population initialization and genetic algorithms for data processing. With the theory of evolution and genetic theory, the application of the Genetic Algorithm will involve several operators: Evolution operators are involved a selection process in it, Genetic Operators is involved in crossover and mutation operators. To check the optimization results, a fitness function is needed, which signifies an overview of the results or solutions that have been coded. During walking, the parent must be used for reproduction, crossing over, and mutation to create offspring. If the Genetic Algorithm is designed correctly, the population will converge and an optimal solution will be obtained

```
#Generate Route Using Genetic Algorithm
source("script/genetic_algorithm_fitness.R")
Capacity	<- 24
speed       	<- 45
fuel_ratio	<- 5
fuel_price	<- 5150
work_hour	<- 8
Loading_time <- 0.5
#Genetic Algorithm Parameter & Method
genetic_algorithm_route <- ga( type = "permutation", fitness = fitness_distance, 
                               capacity = capacity, demand = route$demand, 
                               work_hour = work_hour, speed = speed, loading_time = 
                               loading_time distance = distance_matrix,  
                               service_time =route$service_time, lower = 2, 
                               upper = max(route$node), selection = gaperm_rwSelection,  m
                               utation = gaperm_swMutation, popSize = 20, pcrossover = 0.8, 
                               pmutation = 0.1, maxiter = 1000, suggestions = suggestion_route,
                               monitor = F, seed = 123, parallel=TRUE)
```
### Time Series Generation of Genetic Algorithm
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108051899-0363e280-707e-11eb-91cc-32046f59a6c3.png" />
</p>

## Output

### Genetic Algorithm Output for Route Distribution
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108051800-e62f1400-707d-11eb-8e5f-b856e7383676.png" />
</p>

The route can be output in Excel form and to plot the results of the proposed distribution routes with Geographical Information System (GIS), ggplot2 and ggirpaph are used to visualize the distribution route data

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107483097-26405380-6bb3-11eb-8501-6796125f6060.JPG" />
</p>

This program has the capability for unlimited vehicles. ggplots are required to be scaled for easy viewing

```
plot_gis <- ggplot(indonesia_kota) + geom_sf() + 
    coord_sf(xlim = c(99.8, 100.6), ylim = c(-0.82, -0.22))+  geom_sf_label(aes(label = nama_kota), 
    label.padding = unit(1, "mm"))+ geom_point(data = route1, aes(longitude,latitude), show.legend = F) +
    geom_segment(data = data_gis, aes(x = from_lon, xend = to_lon, y = from_lat, 
    yend = to_lat, color = unit),  size = 0.5, alpha = 0.7, arrow = arrow(type = "closed", angle = 30, 
    length = unit(3, "mm")) ) +geom_point(data = route1[1,], aes(longitude,latitude), color = "red", 
    size = 3) + geom_label_repel(data = route1, aes(longitude,latitude, label = code), size =2.5, 
    alpha = 0.7, segment.size = 0.2) +scale_color_manual(values = c("firebrick", "orange", "dodgerblue", 
    "green3","purple","cyan"))+ theme_minimal() +
    theme(panel.grid = element_blank()) +
    theme(legend.position = "top") +
    theme(plot.title=element_text(hjust=0.5, face="bold"))+
    labs(x = quote(Longitude),
         y = quote(Latitude),
         title = "Proposed Distribution Route",
         subtitle = "Capacity = 24 CBM | Method = Genetic Algorithm  | Date = Choose Date ",
         color = "Driver")
gis <- girafe (ggobj= plot_gis)
gis <- girafe_options(gis, opts_zoom(min =.3 , max=10))
if (interactive()) print(gis)
```

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107485469-6228e800-6bb6-11eb-8994-d1b3d5837dfb.JPG" />
</p>

## Data Verification 

To ensure that the program can run properly. Error Checker will be added to the script genetic_algortihm_fitness.R, the program will detect if there is a negative value or zero value from input parameters. The program will 'stop' if there is a negative value on the input demand, service time. For capacity, vehicle speed, fuel ratio, fuel price and working hour and loading time, the program will 'stop' if there is a negative or zero (0) value

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107483108-293b4400-6bb3-11eb-99f8-2ef70cbad7ae.JPG" />
</p>

## Benchmark Result
Benchmarking program aims to determine how efficiently the program performs computation by comparing the time it takes for the program to get the final result. Benchmarking is done with 100 iteration parameters, 1000 iterations, 10000 iterations on the Genetic Algorithm with a total population of N = 100 populations. Each experiment was used by using a laptop with an Intel i7 7th Generation processor with a CPU Load of 10%-30%.

![alt text](https://user-images.githubusercontent.com/78789134/107481874-77e7de80-6bb1-11eb-81e6-12efad1db31f.JPG)

However, by using population initialization using the Nearest Neighbor Algorithm, 1000 iterations may be enough so that it only takes an average of 263.82 seconds to get the desired result. So, with this result, it is hoped that this program can be used to solve more significant problems and will not take much time to solve them.
