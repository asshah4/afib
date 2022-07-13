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
source("R/intake.R")

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
		"pointblank",
		"naniar"
	)
)

# End this file with a list of target objects.
targets <- list(
	# AF and Cardioversion
	tar_file(file_mina, file.path("data", "mina-data_06-07-22.xlsx")),
	tar_render(pilot, file.path("R", "pilot.Rmd")),
	
	# AF Registry
	tar_file(file_messy, file.path("data", "unprocessed_catheter_ablation.xlsx")),
	tar_file(file_convo, file.path("columns.yml")),
	tar_file(file_af, file.path("data", "af_registry.csv"))
	#tar_make(raw, read_in_messy_data(file_messy, file_convo, file_af))
	
)
