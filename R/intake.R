read_in_messy_data <- function(file_messy, file_convo, file_af) {
	
	# Original messy data
	aa <- 
		read_excel(file_messy, sheet = 1) |> 
		clean_names() |>
		mutate(across(starts_with("type_of"), ~ as.numeric(.x))) |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("length_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("date"), ~ as.character(.x))) |>
		mutate(zip_code = as.numeric(zip_code)) |>
		mutate(procedural_complication = as.numeric(procedural_complication)) |>
		mutate(bsa = as.numeric(bsa)) 
		
	ea <- 
		read_excel(file_messy, sheet = 2) |> 
		clean_names() |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("date"), ~ as.character(.x))) |>
		mutate(procedural_complication = as.numeric(procedural_complication)) |>
		mutate(bsa = as.numeric(bsa)) |>
		mutate(holter_monitor_rate = as.numeric(holter_monitor_rate))
	
	hl <- 
		read_excel(file_messy, sheet = 3) |> 
		clean_names() |>
		mutate(across(starts_with("type_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("date"), ~ as.character(.x))) |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(sex = as.numeric(sex)) 
	
	messy <- bind_rows(aa, ea, hl)
	
	
}
