check_table_scan <- function(raw) {
	tbl_scan <- scan_data(tbl = raw, sections = "OV")
}

check_table_information <- function(raw) {
	
	informant <-
		create_informant(
			tbl = raw,
			tbl_name = "afib_registry",
			label = "AF Registry Data Dictionary"
		) |>
		info_tabular(
			description = "Registry of patients with atrial fibrillation that have undergone catheter ablation in the Illinois Medical District."
		) |>
		info_columns(
			columns = starts_with("DT"),
			info = "Date of event in **YYYY-MM-DD** format."
		) |>
		info_columns(
			columns = ends_with("INTERVAL"),
			info = "Duration in **DAYS** between two relevant dates."
		) |>
		info_columns(
			columns = starts_with("HX") & !ends_with("TX"),
			info = "Presence or absence of clinical morbidity."
		) |>
		{\(x) 
			reduce(
				names(raw),
				~ .x |> info_columns(
					columns = all_of(.y),
					description = snip_variable_labels(eval(parse(text = paste0("raw$", .y))), .y)
				),
				.init = x
			)
		}() |>
		{\(x) 
			reduce(
				names(select(raw, where(is_val_labelled))),
				~ .x |> info_columns(
					columns = all_of(.y), 
					values = snip_value_labels(eval(parse(text = paste0("raw$", .y))))
				),
				.init = x
			)
		}() 
		
}

check_table_quality <- function(raw) {
	
	action_parameters <- action_levels(warn_at = 0.1, stop_at = 0.2)
	
	agent <-
		create_agent(
			tbl = raw,
			tbl_name = "afib_registry",
			label = "AF Registry Data Checks",
			actions = action_parameters
		) |>
		col_is_date(columns = starts_with("DT")) |>
		col_is_numeric(columns = starts_with("HX") & !ends_with("TX")) |>
		col_vals_in_set(
			columns = starts_with("HX") & !ends_with("TX"),
			set = c(0, 1),
		) |>
		col_vals_in_set(columns = "DEMO_ANCESTRY", set = 0:2) |>
		col_is_character(columns = starts_with("NOTES")) |>
		col_is_numeric(columns = starts_with("DEMO")) |>
		col_vals_in_set(columns = ends_with("QUAL"), set = 0:3) |>
		col_vals_in_set(columns = "AF_DX_TYPE", set = 0:2) |>
		col_vals_between(columns = contains("RISK"), left = 0, right = 8) |>
		col_vals_between(columns = ends_with("INTERVAL"), left = 0, right = 5000) |>
		col_is_character(columns = ends_with("OPERATOR")) |>
		interrogate()
		
}

write_out_validity <- function(scan, informant, agent) {
	
	agent_report <- get_agent_report(
		agent,
		title = "AF Registry Data Validity"
	)
	
	informant_report <- get_informant_report(
		informant,
		title = "AF Registry Data Dictionary"
	)
	
	# Exporting the reports
	export_report(scan, filename = "af_summary.html", path = "checks/")
	export_report(informant_report, filename = "af_dictionary.html", path = "checks/")
	export_report(agent_report, filename = "af_validity.html", path = "checks/")
	
}
