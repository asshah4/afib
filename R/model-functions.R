make_models <- function(proc) {
	
	lvidd <- 
		glm(success ~ lvi_dd, family = "binomial", data = proc) 
	
	lvidd_ef <- 
		glm(success ~ lvef + lvi_dd, family = "binomial", data = proc) 
	
	lvidd_la <- 
		glm(success ~ la_vol_index + lvi_dd, family = "binomial", data = proc) 
	
	lvidd_la_ef <-
		glm(success ~ lvef + la_vol_index + lvi_dd, family = "binomial", data = proc) 
	
	list(
		lvidd = lvidd,
		lvidd_ef = lvidd_ef,
		lvidd_la = lvidd_la,
		lvidd_la_ef = lvidd_la_ef
	)
}