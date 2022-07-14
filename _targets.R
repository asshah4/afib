library(targets)
library(tarchetypes)
# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
source("R/options.R")
source("R/intake.R")
source("R/validity.R")

# Set target-specific options such as packages.
tar_option_set(
	packages = c(
		# Cleaning
		"tidyverse",
		"readxl",
		"janitor",
		# Modeling
		"tidymodels",
		# Presenting
		"knitr",
		"gt",
		"gtsummary",
		"xaringanthemer",
		# Validating
		"labelled",
		"pointblank",
		"naniar"
	)
)

# End this file with a list of target objects.
targets <- list(
	# AF and Cardioversion
	tar_file(file_mina, file.path("..", "..", "OneDrive - University of Illinois at Chicago", "data", "afib", "raw_data", "mina-data_06-07-22.xlsx")),
	tar_render(pilot, file.path("R", "pilot.Rmd")),
	
	### AF Registry ----
	
	# Intake
	tar_file(file_messy, file.path("..", "..", "OneDrive - University of Illinois at Chicago", "data", "afib", "raw_data", "unprocessed-catheter-ablation.xlsx")),
	tar_target(messy, read_in_messy_data(file_messy)),
	tar_target(raw, label_data(messy)),
	
	# Validity checking
	tar_target(scan, check_table_scan(raw)),
	tar_target(informant, check_table_information(raw)),
	tar_target(agent, check_table_quality(raw)),
	tar_target(findings, write_out_validity(scan, informant, agent))
	
	
)
