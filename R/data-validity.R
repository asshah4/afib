library(pointblank)
library(convo)

convo <- read_convo("columns.yml")
af <- readr::read_csv("data/af_registry.csv")
columns <- names(af)
evaluate_convo(convo, columns)
parse_stubs(columns)

compare_convo(columns, convo, fx = "union")

raw <- readxl::read_excel("data/unprocessed_catheter_ablation.xlsx", sheet = 1)
