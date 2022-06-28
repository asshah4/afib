make_tables <- function(models) {
	
	lvidd <- 
		tbl_regression(models$lvidd, exponentiate = TRUE) |>
		add_glance_source_note() 
	
	# Adjusted for LVEF
	lvidd_ef <-
		tbl_regression(models$lvidd_ef, exponentiate = TRUE) |>
		add_glance_source_note() 
	
	# Adjusted for LA
	lvidd_la <- 
		tbl_regression(models$lvidd_la, exponentiate = TRUE) |>
		add_glance_source_note() 
	
	# Adjusted for all
	lvidd_la_ef <- 
		tbl_regression(models$lvidd_la_ef, exponentiate = TRUE) |>
		add_glance_source_note() 
	
	tbls <-
		list(
			lvidd = lvidd, 
			lvidd_ef = lvidd_ef, 
			lvidd_la = lvidd_la, 
			lvidd_la_ef = lvidd_la_ef
		)

}
