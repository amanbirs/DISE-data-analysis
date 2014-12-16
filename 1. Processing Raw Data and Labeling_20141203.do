* Analysis of DISE Datasets 
* Date: 3rd, December 2014
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* This file converts .csv 
*
*
*
*
*
*



set more off

*** Importing Raw data -- Only needs to be run once

* File Path for Raw Data (xlsx files)
cd "/Users/amanbirs/Dropbox/WB adolescent girls project/DISE data/Raw Data" /// change this to where the data is on your machine

* converting data from .csv to .dta
foreach i in "DISE_Basic_Data_03-12-2014 12-18-28" "DISE_EnrolmentAndRepeaters_Data_03-12-2014 12-17-16" ///
			"DISE_Facility_Data_03-12-2014 12-17-59" "DISE_General_Data_03-12-2014 12-18-13" ///
			"DISE_RTE_Data_03-12-2014 12-16-46" {
	insheet using "`i'.csv", clear
	
	cap ren schcd school_code
	cap format school_code %11.0g

	cap mkdir "../dta"
	save "../dta/`i'", replace
}


*** Adding District Name, School Code, Block Name and Pincode to all datasets
cd "../dta" ///working in the dta folder now

use "DISE_Basic_Data_03-12-2014 12-18-28.dta", clear
keep distname school_code block_name pincode 
tempfile school_location
save `school_location'

foreach i in "DISE_EnrolmentAndRepeaters_Data_03-12-2014 12-17-16" ///
			"DISE_Facility_Data_03-12-2014 12-17-59" "DISE_General_Data_03-12-2014 12-18-13" ///
			"DISE_RTE_Data_03-12-2014 12-16-46" {
	use "`i'", clear

	merge 1:1 school_code using `school_location'
	drop _merge
	
	save "`i'", replace 
}


*** Applying Value Labels to General Data

use "DISE_General_Data_03-12-2014 12-18-13", clear

label define yesno 0 "Not Applicable" 1 "Yes" 2 "No"

label define rural_urban 1 "Rural" 2 "Urban" 

label define school_category 1 "Primary only" 2 "Primary with Upper Primary(1-8)" 3 "Primary with upper primary and secondary and higher secondary(1-12)" ///
4 "Upper Primary only(6-8)" 5 "Upper Primary with secondary and higher secondary(6-12)" 6 "Primary with upper primary and secondary(1-10)" ///
7 "Upper Primary with secondary(6-10)" 8 "Secondary only(9 & 10)" 9 "Secondary with Hr. Secondary(9-12)" 11 "Hr. Secondary only/Jr. College(11 & 12)"

label define school_type 1 "Boys" 2 "Girls" 3 "Co-educational"

label define school_management 1 "Department of Education" 2 "Tribal/Social Welfare Department" 3 "Local body" 4 "Pvt. Aided" ///
5 "Pvt. Unaided" 6 "others" 7 "Central Govt." 8 "Unrecognised" 97 "Madarsa recognized (by Wakf board/Madarsa Board)" ///
98 "Madarsa unrecognized" 

label define medium_instruction 01 "Assamese" 02 "Bengali" 03 "Gujarati" 04 "Hindi" 05 "Kannada" 06 "Kashmiri"  07 "Konkani" ///
08 "Malayalam" 09 "Manipuri"  10 "Marathi" 11 "Nepali" 12 "Odia" 13 "Punjabi" 14 "Sanskrit" ///
15 "Sindhi"  16 "Tamil"  17 "Telugu"  18 "Urdu"  19 "English"  20 "Bodo"  21 "Mising"  22 "Dogri" ///
23 "Khasi" 24 "Garo" 25 "Mizo" 26 "Bhutia" 27 "Lepcha" 28 "Limboo" 29 "French" 99 "Others" 

label define residential_type 1 "Ashram (Govt.)" 2 "Non-Ashram type (Govt.)" 3 "Private" 4 "Others" /// 
5 "Not Applicable" 6 "Kasturba Gandhi Balika Vidhyalaya (KGBV)"

label values rururb rural_urban
label values schcat school_category
label values schtype school_type
label values schmgt school_management
label values medinstr1 medium_instruction
label values resitype residential_type
label values ppsec_yn schres_yn schshi_yn yesno

save "DISE_General_Data_03-12-2014 12-18-13", replace


*** Applying Value Labels to Facility Data

use "DISE_Facility_Data_03-12-2014 12-17-59", clear

label define yesno 0 "Not Applicable" 1 "Yes" 2 "No"

label define building_type 1 "Private " 2 "Rented" 3 "Government" 4 "Government school in a rent free building" ///
5 "No Building" 6 "Dilapidated" 7 "Under Construction"

label define midday_meal_status 0 "Not applicable" 1 "Not provided" 2 "provided & prepared in school premises" ///
3 "provided but not prepared in school premises"

label define water_source 1 "Hand pumps" 2 "Well" 3 "Tap water" 4 "Others" 5 "None"

label define boundary_type 0 "Not Applicable" 1 "Pucca" 2 "Pucca but broken" 3 "barbed wire fencing" 4 "Hedges" ///
5 "No boundary wall" 6 "Others" 7 "Partial" 8 "Under Construction"

label define electricity_yesno 1 "Yes" 2 "No" 3 "Yes but not functional"

label values kitdevgrant_yn cal_yn hmroom_yn library_yn pground_yn medchk_yn ramps_yn headtch yesno
label values electric_yn electricity_yesno
label values bldstatus building_type
label values mealsinsch midday_meal_status
label values water water_source
label values bndrywall boundary_type 

save "DISE_Facility_Data_03-12-2014 12-17-59", replace


*** Applying Value Labels to RTE Data

use "DISE_RTE_Data_03-12-2014 12-16-46", clear

label define yesno 0 "Not Applicable" 1 "Yes" 2 "No"

label define special_training 1 "School premises" 2 "Other than school premises" 3 "School Premises and Outside "

label define training_type 1 "Residential" 2 "non-residential" 3 "both"

label define midday_meal_status 0 "Not applicable" 1 "Not provided" 2 "provided & prepared in school premises" ///
3 "provided but not prepared in school premises"

label define kitchen_shed 0 "Not applicable" 1 "Available" 2 "Not Available" 3 "Under Construction" 4 "Classroom used as kitchen"

label define midday_meal_source 1 "From nearby school" 2 "NGO" 3 "Self Help Group" 4 "PTA/MTA" 5 "Others" ///
6 "Gram panchayat" 7 "central kitchen"

label define kitchen_dev_grant 0 "Not Applicable" 1 "Yes" 2 "No"

label values approachbyroad cce_yn pcr_maintained pcr_shared smc_yn smcsdp_yn smschildrec_yn spltrg_material_yn txtbkrecd_yn yesno
label values spltrg_place special_training
label values spltrg_type training_type
label values mealsinsch midday_meal_status
label values kitshed kitchen_shed
label values mdm_maintainer midday_meal_source
label values kitdevgrant_yn kitchen_dev_grant

save "DISE_RTE_Data_03-12-2014 12-16-46", replace

