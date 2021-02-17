# Capacitated Vehicle Routing Problem with Time Windows (CVTPTW) calculated with Genetic Algorithm (GA) and visualise in Indonesia Interactive Maps (ggplots &amp; ggiraph)

![alt text](https://img.shields.io/badge/Language-R-brightgreen) ![alt text](https://img.shields.io/badge/Author-Fauzan%20Rahman-blue)

Program Overview 

![alt text](https://user-images.githubusercontent.com/78789134/107484343-debac700-6bb4-11eb-99b1-4763bb52db49.JPG)

## Preface 

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108178803-71201500-7137-11eb-8950-d4a6bde09cda.jpg" />
</p>

Distribution is an activity to transfer goods from the supplier to the agent in a supply chain. Distribution is key to the profits that the company will earn because the distribution will directly affect the cost of the supply chain and the needs of the agent. The right distribution network can be used to achieve a wide range of objectives from supply chains, ranging from low cost to high response to agent demand 

## Overview 

Planning the distribution process is important because with planning, companies can deliver products to consumers on time, in the right place, and good condition. The distribution of products from source to several destinations is certainly a fairly complex problem because the existence of several places of destination for product delivery will cause several distribution lines that are longer travel times. Poor distribution system planning will lead to wasteful transportation costs.

It is necessary to design a more optimal distribution route by considering the shortest distance, maximum capacity of the vehicle, and the working hours of the driver to  minimize the total distribution time and save the company expenses. In addition, lateness in the delivery of products is feared to decrease customer satisfaction. With the design of distribution routes, it is expected that products can be distributed to customers more quickly and optimally.


## Genetic Algorithm Manual Calculation Progress 

### Calculating Nearest Neighbor as Population Initialization
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108173733-14216080-7131-11eb-9043-855f03514984.jpg" />
</p>

### Determing Chromosome & Population Initialization
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108173740-1683ba80-7131-11eb-8d4d-e0cf8acf5f20.jpg" />
</p>

### Chromosome Selection
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108173740-1683ba80-7131-11eb-8d4d-e0cf8acf5f20.jpg" />
</p>


### Chromosome Crossover 
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108173749-197eab00-7131-11eb-97c9-625d9e7a98fc.jpg" />
</p>

### Chromosome Mutation
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108173756-1aafd800-7131-11eb-96dd-30d3888caf79.jpg" />
</p>

## Route Detemination Program - R Programming

### Library & Setup
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176956-32895b00-7135-11eb-9413-6585593d46d0.jpg" />
</p>

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
### Input Data

The data need to be input is in the xls/xlsx format, program_verification.xlsx is the file name to be processed, and sheet = 1, meaning that is the first sheet in program_verification.xlsx

```
# INPUT DATA FOR PROCESSING
int_route <- read_xls("data_input/program_verification.xls", sheet=1)
int_route <- as.data.frame(int_route)
```
### R Program – Convert to Latitude & Longitude In km based on ISO 6709:2008

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176960-34531e80-7135-11eb-8030-a7703fe2aa7c.jpg" />
</p>

Convert Longitude and Latitude to Distance in Kilometres Using this code

```
# 1 | Add dummy for calculation 
degree_dummy <- int_route[,7]
degree <- as.integer(degree_dummy)
minutes_dummy <- 60*(degree_dummy - degree)
minutes <- as.integer(minutes_dummy)
seconds_dummy <- 60*(minutes_dummy - minutes)
### Round seconds to desired accuracy:
seconds       <- round(seconds_dummy, digits=3 )
degree.Latitude <- degree
minutes.Latitude <- minutes
seconds.Latitude <- seconds
# 2 | Convert to km
Latitude.km <- -((degree.Latitude * 110.57) + (minutes.Latitude *1.84) + (seconds.Latitude * 0.03072))
# 3 | Convert to DMS Longitude
degree_dummy1 <- int_route [,8]
degree1 <- as.integer(degree_dummy1)
minutes_dummy1 <- 60*(degree_dummy1 - degree1)
minutes1 <- as.integer(minutes_dummy1)
seconds_dummy1 <- 60*(minutes_dummy1 - minutes1)
### Round seconds to desired accuracy:
seconds1       <- round(seconds_dummy1, digits=3 )
degree.Longitude <- degree1
minutes.Longitude <- minutes1
seconds.Longitude <- seconds1 
Convert to km
Longitude.km <(degree.Longitude * 111.32) + (minutes.Longitude*1.86) + (seconds.Longitude * 0.03092)
int_route$Latitude.km <- Latitude.km
int_route$Longitude.km <- Longitude.km

```

### R Program -Calculating Distance Matrix

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176964-35844b80-7135-11eb-8b75-c80f579da93a.jpg" />
</p>

```
route <- select (int_route,c(node,demand,service_time,Latitude.km,Longitude.km))
route <- route[,c(1,4,5,2,3)]
# 5 | CalcuLatitudee distance matrix 
distance_matrix  <- dist(route[ , 2:3], upper = T, diag = T) %>% as.matrix()
```

### R Program - Creating An Initial Population With The Nearest Neighbor Algorithm
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176971-36b57880-7135-11eb-83ba-6e425804c082.jpg" />
</p>

```
# GENERATE INITIAL POPULATION FOR GENETIC ALGORITHM 
# (DEFAULT = RANDOM)
# Nearest Neighbor Algorithm (NNA)
source("script/nearest_neighbor_population.R")
NNA_suggestion_route <- matrix(ncol = (max(route$node)-1), nrow = 20)
  
  for (i in 1:20) 
{
    find_route <- path(demand = route$demand, distance =  distance_matrix)
    NNA_suggestion_route[i, ] <- find_route$route[2:max(route$node)] %>% as.numeric()
  }
```

### R Program – Calculating Genetic Algorithm
<p align="center">
  <img src="
https://user-images.githubusercontent.com/78789134/108176978-37e6a580-7135-11eb-94bb-6acca186af4f.jpg" />
</p>

Algorithm development carried out is the development of the Nearest Neighbor algorithm as population initialization and genetic algorithms for data processing. With the theory of evolution and genetic theory, the application of the Genetic Algorithm will involve several operators: Evolution operators are involved a selection process in it, Genetic Operators is involved in crossover and mutation operators. To check the optimization results, a fitness function is needed, which signifies an overview of the results or solutions that have been coded. During walking, the parent must be used for reproduction, crossing over, and mutation to create offspring. If the Genetic Algorithm is designed correctly, the population will converge and an optimal solution will be obtained

```
# GENERATE ROUTE USING GENETIC ALGORITHM
source("script/genetic_algorithm_fitness.R")
# 1 | Vehicle Information, Work Hour, Loading & Unloading Time
#Maximum Capacity Load
capacity  <- 24
#Average Vehicle Speed
speed       <- 45
#Mitsubishi Canter 136 PS Fuel Ratio = 1 : 5 km
fuel_ratio  <- 5
#Bio Solar Price = Rp. 5150 
fuel_price  <- 5150
#Effective Work Hour 8 Hour (08:00-17:00 & Break : 1 Hour)
work_hour   <- 8
#Unloading Time (7.2 minute/0.12 hour)
unloading_time <- 0.12
#Loading Time (30 minute/ 0.5 hour)
loading_time <- 0.5

# BENCHMARK USING PACKAGE TICTOC
tictoc::tic()
# 2 | Specify Genetic Algorithm Parameter & Method
# 3 | This code also run Genetic Algorithm Program Automatically
genetic_algorithm_route   <- ga(
        type = "permutation", 
        fitness = fitness_distance, 
        capacity = capacity, 
        demand = route$demand, 
        distance = distance_matrix, 
        service_time =route$service_time, 
        work_hour = work_hour,
        speed = speed,
        lower = 2, 
        upper = max(route$node), 
        selection = gaperm_rwSelection,
        crossover = gaperm_oxCrossover, 
        mutation = gaperm_swMutation, 
        popSize = 20, 
        pcrossover = 0.8, 
        pmutation = 0.1, 
        maxiter = 100, 
        suggestions = NNA_suggestion_route, 
        monitor = F, seed = 123, parallel =TRUE)
# 4 | Genetic Algorithm Result
summary(genetic_algorithm_route)
plot(genetic_algorithm_route)
```
### R Program – Genetic Algorithm Result

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176983-3917d280-7135-11eb-82cd-984073d530a9.jpg" />
</p>

The results of the genetic algorithm with the solution of  genes and the total distance in the form of a fitness function value, (-) in fitness function value minimize the function and the value is cumulative distance that has been calculated with genetic algorithm (-18.08)

## R Program – Convert Genetic Algoritm To Proposed Route Result

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176987-3a48ff80-7135-11eb-8ccc-2ced9a5f6412.jpg" />
</p>

The results of the genetic algorithm after being converted into routes, distances, vehicle allocations, travel times, total outlets visited, distribution times, and cumulative distances 

```
Convert Genetic Algorithm Result to Route Result---source("script/genetic_algorithm_fitness.R")
genetic_algorithm_solution <- genetic_algorithm_solution(genetic_algorithm_route@solution[1, ], capacity = capacity, distance = distance_matrix, demand = route$demand, service_time = route$service_time, fuel_ratio=fuel_ratio, fuel_price = fuel_price, speed =speed, work_hour =work_hour )
genetic_algorithm_explain <- genetic_algorithm_solution[c(1,3,4,5,6,7,8,9)]
genetic_algorithm_explain
```
## R Program-Geographic Information System (GIS) Code for Proposed Route

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108176993-3b7a2c80-7135-11eb-98b5-d1a7f7e6a881.jpg" />
</p>

```
# GEOGRAPHIC INFORMATION SYSTEM (GIS) FOR PROPOSED ROUTE
route1 <- select (int_route,-c(initial_driver,Latitude.km,Longitude.km))
route1 <- select (route1,-c(service_time))
service_time <- unloading_time
route1        <- cbind(route1, service_time)
route1[1,10]   <- loading_time
data_gis <- genetic_algorithm_solution$Route %>% 
  as.data.frame() %>% 
  rename(from = ".") %>% 
  mutate(to = lead(from)) %>% 
  slice(- nrow(.)) %>% 
  left_join(route1, by = c("from" = "node")) %>% 
  rename(from_lon = longitude,
         from_lat = latitude) %>% 
  left_join(route1, by = c("to" = "node")) %>% 
  rename(to_lon = longitude,
         to_lat = latitude) %>% 
  rename(from_outlet = outlet.x  ) %>%
  rename(to_outlet = outlet.y) %>%
  rename(from_outlet_code = code.x) %>%
  rename(to_outlet_code = code.y) %>%
  rename(type = type.y) %>%
  rename(date = date.y) %>%
  rename(service_time = service_time.y) %>%
  rename(demand = demand.y) %>%
  rename(location = location.y) %>%
  select(-demand.x) %>%
  select(-date.x) %>%
  select(-type.x) %>%
  select(-service_time.x)%>%
  select(-location.x)%>%
  #Number Visisted Outlet (Include Depot)
  mutate(unit = c( rep("Driver 1", 5),rep ("Driver 2", 6)))

# 2 | Plot Data to the Map, ggplot, gis location is used by library(indonesia)
indonesia_kota <- id_map("indonesia", "kota")
indonesia_kota <- indonesia_kota[381:399,]
plot_gis <- ggplot(indonesia_kota) + geom_sf() + 
coord_sf(xlim = c(100.1, 100.18), ylim = c(-0.64, -0.59))+  geom_sf_label(aes(label = nama_kota), label.padding = unit(1, "mm"))+ geom_point(data = route1, aes(longitude,latitude), show.legend = F) +geom_segment(data = data_gis, aes(x = from_lon, xend = to_lon, y = from_lat, yend = to_lat, color = unit), size = 0.5, alpha = 0.7, arrow = arrow(type = "closed", angle = 30, length = unit(3, "mm")) ) +geom_point(data = route1[1,], aes(longitude,latitude), color = "red", size = 3) + geom_label_repel(data = route1, aes(longitude,latitude, label = code), size =2.5, alpha = 0.7, segment.size = 0.2) +scale_color_manual(values = c("firebrick", "orange", "dodgerblue", "green3","purple"))+
    theme_minimal() +
    theme(panel.grid = element_blank()) +
    theme(legend.position = "top") +
    theme(plot.title=element_text(hjust=0.5, face="bold"))+
    labs(x = quote(Longitude),
         y = quote(Latitude),
         title = "Proposed Distribution Route on CV. Abro Mandiri",
         subtitle = "Capacity = 24 CBM | Method = Genetic Algorithm  | Date = Verification",
         color = "Driver")
gis <- girafe (ggobj= plot_gis)
gis <- girafe_options(gis, opts_zoom(min =.3 , max=10))
if (interactive()) print(gis)

```
<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108177002-3cab5980-7135-11eb-9a25-6a5c094e2eec.jpg" />
</p>

## Additional Features

### Capability for Large Scale Route Determination 

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108178806-72514200-7137-11eb-937e-b4430bf14d54.jpg" />
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

### Data Verification 

To ensure that the program can run properly. Error Checker will be added to the script genetic_algortihm_fitness.R, the program will detect if there is a negative value or zero value from input parameters. The program will 'stop' if there is a negative value on the input demand, service time. For capacity, vehicle speed, fuel ratio, fuel price and working hour and loading time, the program will 'stop' if there is a negative or zero (0) value

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108177006-3fa64a00-7135-11eb-8fda-afbc49f4de3e.jpg" />
</p>

### Benchmark Result
Benchmarking program aims to determine how efficiently the program performs computation by comparing the time it takes for the program to get the final result. Benchmarking is done with 100 iteration parameters, 1000 iterations, 10000 iterations on the Genetic Algorithm with a total population of N = 100 populations. Each experiment was used by using a laptop with an Intel i7 7th Generation processor with a CPU Load of 10%-30%.

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/108178797-6f565180-7137-11eb-8761-340fb6d97d24.jpg" />
</p>

However, by using population initialization using the Nearest Neighbor Algorithm, 1000 iterations may be enough so that it only takes an average of 263.82 seconds to get the desired result. So, with this result, it is hoped that this program can be used to solve more significant problems and will not take much time to solve them.
