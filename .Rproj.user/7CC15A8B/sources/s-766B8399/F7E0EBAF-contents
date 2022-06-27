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
source("R/intake-functions.R")
source("R/tidy-functions.R")

# Set target-specific options such as packages.
tar_option_set(
	packages = c(
		"tidyverse",
		"tidymodels",
		"knitr",
		"gt",
		"gtsummary"
	)
)

# End this file with a list of target objects.
targets <- list(
	# Files
	tar_file(file_mina, file.path("data", "mina-data_06-07-22.xlsx")),
	
	# Intake
	tar_target(raw, read_mina_data(file_mina)),
	
	# Tidy
	tar_target(proc, tidy_data(raw)),
	
	# Explore
	tar_render(pilot, file.path("R", "pilot.Rmd"))
)
