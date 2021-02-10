fitness_distance <- function(x, capacity, demand, distance, service_time, work_hour, speed, loading_time,  ...)
{
  vehicle_load        <- capacity
  visited_outlet      <- 1
  allocated_vehicle   <- 1
  max_time            <- work_hour
  total_distribution_time <- 0
  total_distribution_time_prev = 0
  dummy = 0
  final_visits = c()
  final_distribution_time = 0
  vehicle_speed <- speed
  loading_time <- loading_time
  
  #Error Checker, Negative Value is not Allowed, to make sure Program is running properly
  demand_check <- as.vector(int_route$demand)
  if (any(demand_check<0)) stop ("Program is not Running, please check the Demand value again, One or More value of the Demand is NEGATIVE (-)")
  service_time_check <- as.vector(int_route$service_time)
  if (any(service_time_check<0)) stop ("Program is not Running, please check the service time value again, the value of Service Time is NEGATIVE")
  if (any(capacity<=0)) stop ("Program is not Running, please check capacity value again, the value of Capacity is 0 or NEGATIVE")
  if (any(speed<=0)) stop ("Program is not Running, please check the vehicle speed value again, value of Vehicle Speed is 0 or NEGATIVE")
  if (any(fuel_ratio<=0)) stop ("Program is not Running, please check the fuel ratio value again, the value of Fuel Ratio is 0 or NEGATIVE")
  if (any(fuel_price<=0)) stop ("Program is not Running, please check the fuel price value again, the value of Fuel Ratio is 0 or NEGATIVE")
  if (any(work_hour<=0)) stop ("Program is not Running, please check work hour value again, the value of Work Hour is 0 or NEGATIVE")
  if (any(loading_time<=0)) stop ("Program is not Running, please check loading time value again, the value of Loading Time is 0 or NEGATIVE")
  
   for (i in x)
  {
    dummy = dummy + 1
    # Go to the outlet
    visited_outlet 		<- c(visited_outlet, i)
    visit                 <- c(visited_outlet,1) 
    total_distribution_time <- embed(visit, 2)[ , 2:1] %>% 
      distance[.] %>%
      sum() / vehicle_speed + service_time[] 
    
    if (vehicle_load > demand[] & max_time>total_distribution_time){
      final_visits = visit
      final_distribution_time = total_distribution_time
      vehicle_load 		    <- vehicle_load - demand[  ]
    }
    else
    {
      visit = final_visits
      # dummy = 0
      total_distribution_time_prev = total_distribution_time_prev 
      # Go back to depot
      vehicle_load 		    <- capacity
      visited_outlet 		  <- c(visited_outlet[-length(visited_outlet)], 1,i)
      allocated_vehicle 	<- allocated_vehicle + 1
      
      # Go to the outlet
      vehicle_load 		            <- vehicle_load - demand[  ]
    }
    
  }
  visited_outlet <- c(visited_outlet,1)
  total_distance <- embed(visited_outlet, 2)[ , 2:1] %>% distance[.] %>% sum()
  return(total_distance)
}

genetic_algorithm_solution <- function(x, capacity, demand, distance, service_time,speed,work_hour, loading_time, ...){
  
  vehicle_speed     <- speed
  vehicle_load      <- capacity
  max_time          <- work_hour
  visited_outlet    <- 1
  total_distribution_time <- 0
  total_demand            <- NULL
  allocated_vehicle       <- 1
  total_distribution_time_prev = 0
  dummy = 0
  final_visits = c()
  final_distribution_time = 0
  total_service_time <- NULL
  loading_time <- loading_time
 
  for (i in x)
  {
    dummy = dummy + 1
    # Go to the outlet
    visit                   <- c(visited_outlet,1) 
    total_distribution_time <- embed(visit, 2)[ , 2:1] %>% 
      distance[.] %>%
      sum() / speed + service_time[i]  
    
    if (vehicle_load > demand[i] & max_time>total_distribution_time)
    {
      final_visits = visit
      final_distribution_time = total_distribution_time
    } 
    else
    {
      visit = final_visits
      total_demand 		    <- c(total_demand, capacity - vehicle_load)
      total_service_time <- c(total_service_time, max_time) 
      # dummy = 0
      
      total_distribution_time_prev = total_distribution_time_prev 
      # Go back to depot
      vehicle_load 		    <- capacity
      visited_outlet 		<- c(visited_outlet[length(visited_outlet)], 1)
      allocated_vehicle 	<- allocated_vehicle + 1
      
      # Go to the outlet
      total_distribution_time     <- embed(visit, 2)[ , 2:1]%>% distance[] %>% sum()/speed + service_time[] -total_distribution_time_prev
      vehicle_load 		        <- vehicle_load - demand[  ]
    }
    
  }
  
  total_demand <- c(total_demand, capacity - vehicle_load)
  names(total_demand)<- paste0("Driver-", 1:length(total_demand))
  visited_outlet <- c(visited_outlet,1)
  total_demand_new <- demand[c(visited_outlet)]
  f 		    <- total_demand_new
  g         <- split(f[f>0],cumsum(f==0)[f>0])
  h 	      <- unlist(lapply(g, function(x) sum(x)))
  names(h ) <- paste0("Driver ", 1:length(h ))
  
  service_new <- service_time[c(visited_outlet)]
  k 			<- service_new
  l       <- split(k[k>0],cumsum(k==0)[k>0])
  m 	    <- unlist(lapply(l, function(x) sum(x)))
  
  
  
  total_distance <- embed(visited_outlet, 2)[ , 2:1] %>% distance[]
  sequence1 		<- visited_outlet
  r 			<- sequence1
  c 			<- sequence1
  a 			<- split(r[r>1],cumsum(r==1)[r>1])
  b 			<- split(c[c>1],cumsum(c==1)[c>1])
  lst_outlet3		<- lapply(a, function(x) c(1, x))
  lst_outlet4 		<- lapply(b, function(x) c(1, x, 1))
  names(lst_outlet4)	<- paste0("Driver ", 1:length(lst_outlet3))
  names(lst_outlet3)	<- paste0("Driver ", 1:length(lst_outlet3))
  names(total_demand)	<- paste0("Driver ", 1:length(total_demand))
  z 			<- lengths(lst_outlet3)
  v 			<- total_distance
  distance_outlet 			<- split(v, rep(1:allocated_vehicle, z))
  driver_distance 	<- unlist(lapply(distance_outlet, function(x) sum(x)))
  names(driver_distance )<- paste0("Driver ", 1:length(driver_distance ))
  Total_Dist 		<- Reduce("+",driver_distance )
  driving_time 		<- driver_distance/speed
  trans_cost <- (driver_distance/fuel_ratio)*fuel_price
  dist_total <- driving_time + m + loading_time
  result <- list('-------Proposed Distribution Route -------',
                 "Route" = visited_outlet,
                 "Route Sequence (Node)"    	= lst_outlet4,
                 "Number Visited Outlet (Include depot)" 	= z,
                 "Distance (Kilometres)"  	= driver_distance,
                 "Transportation Cost (Rupiah)"=trans_cost,
                 "Total Demand (Cubic Metres(CBM))"	= h,
                 "Distribution Time (Hour)"	= dist_total,
                 "Cumulative Distance (Kilometres)"	= Total_Dist, 
                 "Allocated Vehicle (Number)" 	= allocated_vehicle,
                 "Outlet Distance (Kilometres)" 	= distance_outlet)
  
  return(result)
}
