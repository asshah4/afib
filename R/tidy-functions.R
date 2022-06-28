tidy_data <- function(raw) {
	raw |>
		mutate(success = as.factor(success)) |>
		mutate(across(chronic_lung_disease:icd_pm, ~ replace_na(.x, 0))) |>
		mutate(across(c(anti_arrhythmics, rate_controlling_agents, anticoagulants), ~ replace_na(.x, "None"))) 
	
}