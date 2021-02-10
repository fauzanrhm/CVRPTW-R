# Initial Path Algorithm

path <- function(distance, demand){
  
  visited_outlet <- NULL
  allocated_vechicle <- 1
  post <- 1:ncol(distance)
  names(demand) <- 1:length(demand)
  
  # Randomly select initial outlet
  initial_outlet <- sample(2:length(demand), 1)
  
  while (any(demand != 0))
  {
    # Visit Available Outlet Which not Visited yet
    available_outlet <- which(demand != 0)
    
    # Calculate the distance to unvisited outlet
    initial_dist <- distance[ c(available_outlet), initial_outlet] 
    
    # Don't Visit Outlet Twice
    initial_dist <- initial_dist[ which(names(initial_dist) != initial_outlet)]
    
    visited_outlet <- c(visited_outlet, initial_outlet)
    
    #To Make Sure Program Don't Visit Outlet Twice
    demand[ initial_outlet ] <- 0
    
    if ( length(initial_dist)>1)
    {
      # Visit Shortest Edge Outlet
      initial_outlet <- which(initial_dist == min(initial_dist))%>% names()%>% as.numeric()
    } 
    else 
    {
      # If not, go to the next Outlet
      initial_outlet <- which(demand != 0)
    }
  }
  
  visited_outlet <- c(1, visited_outlet, 1)
  names(visited_outlet) <- NULL
  cumulative_distance <- embed(visited_outlet, 2)[ , 2:1] %>% distance[.] %>% sum()
  
  result <- list(route = visited_outlet,
                 cumulative_distance = cumulative_distance)
  return(result)
}

# Nearest Neighbor Algorithm 

nearest_neighbor <- function(x, demand, capacity, distance, iteration){
   #Initial
  best_route <- list(cumulative_distance = Inf)
  
  #Iteration = Npopulation
  for (i in 1:iteration) {
    find_route <- path(demand = demand, distance =  distance)
    
    if (best_route$cumulative_distance > find_route$cumulative_distance) {
      best_route <- find_route
    }
  }
}
