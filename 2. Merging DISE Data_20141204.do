* Making master Dataset for Jharkhand DISE Data
* Date: 4th, December 2014
* author: Amanbir Singh, amanbir.s@gmail.com

use "DISE_General_Data_03-12-2014 12-18-13", clear
merge 1:1 school_code using "DISE_Basic_Data_03-12-2014 12-18-28"
drop _merge
merge 1:1 school_code  using "DISE_Facility_Data_03-12-2014 12-17-59"
drop _merge
merge 1:1 school_code using "DISE_RTE_Data_03-12-2014 12-16-46"
drop _merge
merge 1:1 school_code  using "DISE_RTE_Data_03-12-2014 12-16-46"
drop _merge 
merge 1:1 school_code using "DISE_EnrolmentAndRepeaters_Data_03-12-2014 12-17-16"
drop _merge

save "Aggregated DISE Dataset", replace
