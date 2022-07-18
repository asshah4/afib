# Take the multiple excel files and combine them into something clean
read_in_messy_data <- function(file_messy) {
	
	# Original messy data
	# Three different sheets in original excel file
	# Each one is slightly different in terms of column names, keys, etc
	aa <- 
		read_excel(file_messy, sheet = 1) |>
		clean_names() |>
		mutate(across(starts_with("type_of"), ~ as.numeric(.x))) |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("length_of"), ~ as.numeric(.x))) |>
		mutate(zip_code = as.numeric(zip_code)) |>
		mutate(procedural_complication = as.numeric(procedural_complication)) |>
		mutate(bsa = as.numeric(bsa)) 
		
	ea <- 
		read_excel(file_messy, sheet = 2) |> 
		clean_names() |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(procedural_complication = as.numeric(procedural_complication)) |>
		mutate(bsa = as.numeric(bsa)) |>
		mutate(holter_monitor_rate = as.numeric(holter_monitor_rate))
	
	hl <- 
		read_excel(file_messy, sheet = 3) |> 
		clean_names() |>
		mutate(across(starts_with("type_of"), ~ as.numeric(.x))) |>
		mutate(across(starts_with("cause_of"), ~ as.numeric(.x))) |>
		mutate(across(contains("note"), ~ as.character(.x))) |>
		mutate(sex = as.numeric(sex)) 
	
	
	# Rename according to a system
	messy <- 
		bind_rows(aa, ea, hl) |>
		rename(
			ID_AUTHOR = co_author,
			ID_DNA = dna_id,
			ID_PATIENT = uic_mrn_or_va_study_id_number,
			ID_HOSPITAL = hospital,
			DT_ENROLLMENT = date_consented,
			LAB_BLOOD = blood,
			DEMO_INSURANCE = insurance,
			DT_DX = date_of_diagnosis,
			DT_BIRTH = dob,
			DEMO_SEX = sex,
			DEMO_ANCESTRY = ancestry,
			DEMO_AGE = age,
			DEMO_BMI = bmi,
			DEMO_BSA = bsa,
			DEMO_DM = dm,
			HX_SMOKING = smoking_hx,
			DEMO_ZIP = zip_code,
			HX_HTN = htn,
			HX_OSA = osa,
			HX_OSA_TX = osa_treated,                                           
			HX_CAD = cad,                                                   
			NOTES_CAD = notes_on_cad,                                          
			HX_ESRD = esrd,
			HX_CKD = ckd,
			HX_CVA = cva,
			HX_PVD = pvd,
			HX_HYPERTHYROID = hyperthyroidism,
			HX_HYPERTHYROID_TX = hyperthyroidism_treated,
			HX_COPD = copd_or_asthma,
			HX_PHTN = pulmonary_htn,
			HX_CHF = chf,
			HX_VHD = valvular_heart_disease_vhd,
			HX_FAMILY_AF = fh_of_a_fib,
			NOTES_VHD = notes_on_vhd,
			DT_ECHO = date_of_echocardiogram,
			ECHO_SIZE_LA_QUAL = la_size,
			ECHO_VOLUME_LA_4C = la_4c,
			ECHO_VOLUME_LA_2C = la_2c,
			ECHO_VOLUME_LA_INDEX = indexed_la_volume_m_l_m2,
			ECHO_AREA_RA = ra_area,
			ECHO_AREA_RA_QUANT = ra_area,
			ECHO_AREA_RA_INDEX = indexed_ra_rea_cm_m2,
			ECHO_FUNCTION_LV_QUAL = ef,
			NOTES_ECHO = notes_on_echo,
			AF_DX_TYPE = type_of_af,
			AF_RISK_CHADSVASC = chadsvasc,
			AF_RISK_HASBLED = hasbled,
			DT_ABLATION_INDEX = date_of_index_ablation,
			NOTE_ABLATION_INDEX = notes_on_ablation,
			AF_ABLATION_INDEX_TYPE = ablation_type,
			AF_ABLATION_INDEX_ISOLATION = successful_ablation,
			AF_MONITOR_RATE = holter_monitor_rate,
			DT_MONITOR = date_of_holter_monitor,
			AF_RECURRENCE = afib_recurrence,
			DT_RECURRENCE = date_of_recurrence,
			AF_RECURRENCE_INTERVAL = interval_for_recurrence_days,
			AF_PPM = pacemaker_implant,
			DT_PPM = date_of_pacemaker_implantation,
			NOTES_PPM = notes_on_pacemaker,
			MED_AAD = administration_of_aad,
			MED_AAD_TYPE = type_of_aad,
			MED_AAD_DOSE = dose_of_aad_mg,
			MED_OAC = oral_anticoagulation,
			MED_OAC_TYPE = type_of_anticoagulation,
			NOTES_OAC = notes_on_type_of_anticoagulation,
			EVENT_HOSPITALIZATION = hospitalization_within_12_months_of_index_ablation,
			EVENT_HOSPITALIZATION_TYPE = cause_of_hospitalization,
			NOTES_HOSPITALIZATION = notes_on_cause_of_hospitalization,
			EVENT_HOSPITALIZATION_LENGTH = length_of_hospital_stay,
			EVENT_ICU = icu_admission,
			EVENT_ICU_LENGTH = length_of_icu_admission,
			EVENT_ICU_TYPE = cause_of_icu_admission,
			NOTES_ICU = notes_on_cause_of_icu_admission,
			EVENT_CVA = cva_post_ablation,
			EVENT_COMPLICATION = procedural_complication,
			NOTES_COMPLICATION = notes_on_complication,
			EVENT_LDKA_INTERVAL = months_of_followup,
			EVENT_DEATH = death,
			DT_DEATH = date_of_death,
			EVENT_DEATH_TYPE = cause_of_death,
			NOTES_DEATH = notes_on_death,
			AF_ABLATION_TOTAL = total_number_of_redo_ablation,
			DT_ABLATION_REDO_1 = date_of_redo_ablation,
			AF_ABLATION_REDO_1 = redo_ablation,
			NOTES_ABLATION_REDO_1 = notes_redo_ablation
		) |>
		mutate(
			HX_CHF_TYPE = if_else(h_fr_ef_lvef_50_percent == 1, 1, 2),
		) |>
		mutate(
			EVENT_LDKA_INTERVAL = round(EVENT_LDKA_INTERVAL * 30.4),
			AF_RECURRENCE_INTERVAL = round(AF_RECURRENCE_INTERVAL)
		) |>
		select(-c(h_fr_ef_lvef_50_percent, h_fp_ef)) |>
		add_column(
			DEMO_WT = NA,
			DEMO_HT = NA,
			HX_CAD_TX = NA,
			HX_CABG = NA,
			HX_VHD_TX = NA,
			LAB_CREATININE = NA,
			LAB_HEMOGLOBIN = NA,
			LAB_BNP = NA,
			LAB_PROBNP = NA,
			LAB_TROPONIN = NA,
			LAB_SODIUM = NA,
			ECHO_VALVE_DZ = NA,
			ECHO_VALVE_TYPE = NA,
			ECHO_VALVE_SEVERITY = NA,
			ECHO_VOLUME_LV = NA,
			ECHO_STRAIN_LA = NA,
			ECHO_STRAIN_LV = NA,
			ECHO_FUNCTION_LV_QUANT = NA,
			ECHO_SIZE_LV_QUANT = NA,
			ECHO_SIZE_LV_QUAL = NA,
			ECHO_LVH_TYPE = NA,
			ECHO_LVH_SEVERITY = NA,
			ECHO_FUNCTION_RV = NA,
			ECHO_SIZE_RV_QUAL = NA,
			DT_CMR = NA,
			CMR_NOTES = NA,
			AF_DX_BURDEN = NA,
			AF_DCCV = NA,
			AF_DCCV_TOTAL = NA,
			AF_MONITOR_BURDEN = NA,
			NOTES_MONITOR = NA,
			DT_AAD = NA,
			MED_BB = NA,
			MED_BB_TYPE = NA,
			MED_BB_DOSE = NA,
			MED_CCB = NA,
			MED_CCB_TYPE = NA,
			MED_CCB_DOSE = NA,
			DT_HOSPITALIZATION = NA,
			DT_ICU = NA,
			EVENT_ICU_INTERVAL = NA,
			EVENT_HOSPITALIZATION_INTERVAL = NA,
			EVENT_LDKA = NA,
			DT_LDKA = NA,
			NOTE_LDKA = NA,
			EVENT_DEATH_INTERVAL = NA,
			AF_ABLATION_INDEX_ENERGY = NA,
			AF_ABLATION_INDEX_MAPPING = NA,
			AF_ABLATION_INDEX_OPERATOR = NA,
			AF_ABLATION_INDEX_LESIONS = NA,
			AF_ABLATION_INDEX_VOLTAGE = NA,
			AF_ABLATION_REDO_1_ENERGY = NA,
			AF_ABLATION_REDO_1_MAPPING = NA,
			AF_ABLATION_REDO_1_OPERATOR = NA,
			AF_ABLATION_REDO_1_LESIONS = NA,
			AF_ABLATION_REDO_1_VOLTAGE = NA,
			AF_ABLATION_REDO_1_TYPE = NA,
			AF_ABLATION_REDO_1_ISOLATION = NA,
			DT_ABLATION_REDO_2 = NA,
			AF_ABLATION_REDO_2 = NA,
			AF_ABLATION_REDO_2_ENERGY = NA,
			AF_ABLATION_REDO_2_MAPPING = NA,
			AF_ABLATION_REDO_2_OPERATOR = NA,
			AF_ABLATION_REDO_2_LESIONS = NA,
			AF_ABLATION_REDO_2_VOLTAGE = NA,
			AF_ABLATION_REDO_2_TYPE = NA,
			AF_ABLATION_REDO_2_ISOLATION = NA,
			NOTE_ABLATION_REDO_2 = NA,
			DT_ABLATION_REDO_3 = NA,
			AF_ABLATION_REDO_3 = NA,
			AF_ABLATION_REDO_3_ENERGY = NA,
			AF_ABLATION_REDO_3_MAPPING = NA,
			AF_ABLATION_REDO_3_OPERATOR = NA,
			AF_ABLATION_REDO_3_LESIONS = NA,
			AF_ABLATION_REDO_3_VOLTAGE = NA,
			AF_ABLATION_REDO_3_TYPE = NA,
			AF_ABLATION_REDO_3_ISOLATION = NA,
			NOTE_ABLATION_REDO_3 = NA,
			DT_ABLATION_REDO_4 = NA,
			AF_ABLATION_REDO_4 = NA,
			AF_ABLATION_REDO_4_ENERGY = NA,
			AF_ABLATION_REDO_4_MAPPING = NA,
			AF_ABLATION_REDO_4_OPERATOR = NA,
			AF_ABLATION_REDO_4_LESIONS = NA,
			AF_ABLATION_REDO_4_VOLTAGE = NA,
			AF_ABLATION_REDO_4_TYPE = NA,
			AF_ABLATION_REDO_4_ISOLATION = NA,
			NOTE_ABLATION_REDO_4 = NA,
			DT_ABLATION_REDO_5 = NA,
			AF_ABLATION_REDO_5 = NA,
			AF_ABLATION_REDO_5_ENERGY = NA,
			AF_ABLATION_REDO_5_MAPPING = NA,
			AF_ABLATION_REDO_5_OPERATOR = NA,
			AF_ABLATION_REDO_5_LESIONS = NA,
			AF_ABLATION_REDO_5_VOLTAGE = NA,
			AF_ABLATION_REDO_5_TYPE = NA,
			AF_ABLATION_REDO_5_ISOLATION = NA,
			NOTE_ABLATION_REDO_5 = NA,
			SX_AF_QOL = NA,
			SX_HF_KCCQ = NA,
			SX_HF_MINNESOTA = NA,
			HX_FAMILY_CHF = NA
		) |>
		mutate(across(starts_with("DT"), as.Date)) |>
		mutate(across(starts_with("NOTES"), as.character))
	
}

# Add labels to the data
label_data <- function(messy) {
	
	raw <-
		messy |>
		set_variable_labels(
			ID_HOSPITAL = "Hospital site",
			ID_AUTHOR = "Name of reviewer",
			DEMO_ANCESTRY = "Genetic ancestry",
			HX_CHF_TYPE = "Preserved or reduced heart failure (<= 50)",
			SX_AF_QOL = "Atrial Fibrillation Quality of Life Score",
			SX_HF_MINNESOTA = "Minnesota Heart Failure Symptoms Score",
			SX_HF_KCCQ = "Kansas City Cardiomyopathy Questionnaire Score",
		) |>
		set_value_labels(
			ID_HOSPITAL = c(UIC = 1, JBVA = 2, ACMC = 3, MS = 4),
			HX_CHF_TYPE = c(Reduced = 1, Preserved = 2),
			DEMO_ANCESTRY = c(European = 0, African = 1, Hispanic = 2),
			ECHO_FUNCTION_LV_QUAL = c(
				"Normal (>= 55%)" = 0,
				"Mildly Reduced (45-55%)" = 1,
				"Moderately Reduced (30-35%)" = 2,
				"Severely Reduced (< 30%)" = 3
			), 
			ECHO_SIZE_LA_QUAL = c(
				"Normal" = 0,
				"Mildly Dilated" = 1,
				"Moderately Dilated" = 2,
				"Severely Dilated" = 3
			),
			AF_DX_TYPE = c(Paroxysmal = 0, Permanent = 1, Persistent = 2),
			AF_ABLATION_INDEX_TYPE = c(PVI = 1, Maze = 2),
			MED_AAD_TYPE = c(Amiodarone = 1, Sotalol = 2, Propafenone = 3, Flecanide = 4, Procainamide = 5, Mexiletine = 6, Disopyramide = 7, Dofetilide = 8, Dronedarone = 9),
			MED_OAC_TYPE = c(Warfarin = 1, Heparin = 2, LMWH = 3, NOAC = 4),
			EVENT_HOSPITALIZATION_TYPE = c(Cardiac = 1, Noncardiac = 2),
			EVENT_ICU_TYPE = c(Cardiac = 1, Noncardiac = 2),
			EVENT_DEATH_TYPE = c(Cardiac = 1, Noncardiac = 2)
		)
	
}

snip_value_labels <- function(x) {
	
	if (!is_vector(x)) {
		stop("Requires a column from a data set that has been `labelled`.")
	}
	
	vals <- unname(val_labels(x))
	labs <- names(val_labels(x))
	
	if (is.null(labs)) {
		vals <- labs <- levels(factor(x))
	}
	
	
	# Output
	glue::glue("{vals} = {labs}\n")
	
}


snip_variable_labels <- function(x, y) {
	
	if (!is_vector(x)) {
		stop("Requires a column from a data set that has been `labelled`.")
	}
	
	labs <- var_label(x)
	
	if (is.null(labs)) {
		labs <- y
	}
	
	glue::glue("{labs}")
	
}

is_var_labelled <- function(x) {
	
	var_lab <- var_label(x)
	
	if (!is.null(var_lab)) {
		TRUE
	} else {
		FALSE
	}
	
}

is_val_labelled <- function(x) {
	
	val_lab <- val_labels(x)
	
	if (!is.null(val_lab)) {
		TRUE
	} else {
		FALSE
	}
	
}
