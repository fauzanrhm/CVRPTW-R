# Capacitated Vehicle Routing Problem with Time Windows (CVTPTW) calculated with Genetic Algorithm (GA) and visualise in Indonesia Interactive Maps (ggplots &amp; ggiraph)

![alt text](https://user-images.githubusercontent.com/78789134/107484343-debac700-6bb4-11eb-99b1-4763bb52db49.JPG)

Distribution is an activity to transfer goods from the supplier to the agent in a supply chain. Distribution is key to the profits that the company will earn because the distribution will directly affect the cost of the supply chain and the needs of the agent. The right distribution network can be used to achieve a wide range of objectives from supply chains, ranging from low cost to high response to agent demand 

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107484038-72d85e80-6bb4-11eb-95ee-e6609cf726e0.JPG" />
</p>

Planning the distribution process which is important so that companies can deliver products to consumers on time, in the right place, and good condition. The distribution of products from source to several destinations is certainly a fairly complex problem because the existence of several places of destination for product delivery will cause several distribution lines that are longer travel times. Poor distribution system planning will lead to wasteful transportation costs.

It is necessary to design a more optimal distribution route by considering the shortest distance, maximum capacity of the vehicle, and the working hours of the driver to  minimize the total distribution time and save the company expenses. In addition, lateness in the delivery of products is feared to decrease customer satisfaction. With the design of distribution routes, it is expected that products can be distributed to customers more quickly and optimally.

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107481887-7ae2cf00-6bb1-11eb-9b8a-3694cfbc7ac7.png" />
</p>

Algorithm development carried out is the development of the Nearest Neighbor algorithm as population initialization and genetic algorithms for data processing. With the theory of evolution and genetic theory, the application of the Genetic Algorithm will involve several operators: Evolution operators are involved a selection process in it, Genetic Operators is involved in crossover and mutation operators. To check the optimization results, a fitness function is needed, which signifies an overview of the results or solutions that have been coded. During walking, the parent must be used for reproduction, crossing over, and mutation to create offspring. If the Genetic Algorithm is designed correctly, the population will converge and an optimal solution will be obtained

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107481881-79b1a200-6bb1-11eb-9f80-0a4618366f28.png" />
</p>

The route can be output in Excel form and to plot the results of the proposed distribution routes with Geographical Information System (GIS), ggplot2 and ggirpaph are used to visualize the distribution route data

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107483097-26405380-6bb3-11eb-8501-6796125f6060.JPG" />
</p>

To ensure that the program can run properly. Error Checker will be added to the script genetic_algortihm_fitness.R, the program will detect if there is a negative value or zero value from input parameters. The program will 'stop' if there is a negative value on the input demand, service time. For capacity, vehicle speed, fuel ratio, fuel price and working hour and loading time, the program will 'stop' if there is a negative or zero (0) value

<p align="center">
  <img src="https://user-images.githubusercontent.com/78789134/107483108-293b4400-6bb3-11eb-99f8-2ef70cbad7ae.JPG" />
</p>

Benchmarking program aims to determine how efficiently the program performs computation by comparing the time it takes for the program to get the final result. Benchmarking is done with 100 iteration parameters, 1000 iterations, 10000 iterations on the Genetic Algorithm with a total population of N = 100 populations. Each experiment was used by using a laptop with an Intel i7 7th Generation processor with a CPU Load of 10%-30%.

![alt text](https://user-images.githubusercontent.com/78789134/107481874-77e7de80-6bb1-11eb-81e6-12efad1db31f.JPG)
