* Making master Dataset for Jharkhand DISE Data
* Date: 4th, December 2014
* author: Amanbir Singh, amanbir.s@gmail.com


set more off

** Change this location to where the data is saved on your computer
cd "/Users/amanbirs/Dropbox/WB adolescent girls project/DISE data/dta"

use "Aggregated DISE Dataset.dta", clear


** Encoding 
sort distname
encode distname, gen(dist_number) 


/*
** Generating Variables for number of students
* For boys, girls and total: generating the total number of students in elementary school (1-5),
* middle school (6-8) for the state as a whole and by district and the average number of students
* per school.

gen boys_elementary = c1_totb + c2_totb + c3_totb + c4_totb + c5_totb
egen total_boys_elementary = total(boys_elementary)
bysort dist_number: egen total_boys_elem_dist = total(boys_elementary)
bysort dist_number: egen mean_boys_elem_dist = mean(boys_elementary)


gen girls_elementary = c1_totg + c2_totg + c3_totg + c4_totg + c5_totg
egen total_girls_elementary = total(girls_elementary)
bysort dist_number: egen total_girls_elem_dist = total(girls_elementary)
bysort dist_number: egen mean_girls_elem_dist = mean(girls_elementary)


gen boys_middle_school = c6_totb + c7_totb + c8_totb
egen total_boys_middle = total(boys_middle)
bysort dist_number: egen total_boys_middle_dist = total(boys_middle)
bysort dist_number: egen mean_boys_middle_dist = mean(boys_middle)


gen girls_middle_school = c6_totg + c7_totg + c8_totg
egen total_girls_middle = total(girls_middle)
bysort dist_number: egen total_girls_middle_dist = total(girls_middle)
bysort dist_number: egen mean_girls_middle_dist = mean(girls_middle)


gen students_elementary_school = c1_totb + c2_totb + c3_totb + c4_totb + c5_totb + c1_totg + c2_totg + c3_totg + c4_totg + c5_totg
egen total_students_elementary = total(students_elementary_school)
bysort dist_number: egen total_students_elem_dist = total(students_elementary_school)
bysort dist_number: egen mean_students_elem_dist = mean(students_elementary_school)


gen students_middle_school = c6_totb + c7_totb + c8_totb + c6_totg + c7_totg + c8_totg
egen total_students_middle = total(students_middle_school)
bysort dist_number: egen total_students_middle_dist = total(students_middle_school)
bysort dist_number: egen mean_students_middle_dist = mean(students_middle_school)


** Generating totals by class
egen c1_total_students = total(c1_totb + c1_totg)
egen c2_total_students = total(c2_totb + c2_totg)
egen c3_total_students = total(c3_totb + c3_totg)
egen c4_total_students = total(c4_totb + c4_totg)
egen c5_total_students = total(c5_totb + c5_totg)

*/




* reshaping the data, but only for enrollment & fail
*preserve

keep *_tot* fail* school_code rururb medinstr1 distname dist_number

reshape long c1_tot c2_tot c3_tot c4_tot c5_tot c6_tot c7_tot c8_tot fail1 ///
fail2 fail3 fail4 fail5 fail6 fail7 fail8, i(school_code) j(gender b g)

encode gender, gen(sex)
drop gender spltrg_totev

ren c1_tot c1
ren c2_tot c2
ren c3_tot c3
ren c4_tot c4
ren c5_tot c5
ren c6_tot c6
ren c7_tot c7
ren c8_tot c8


reshape long c fail, i(school_code sex) j(class 1 2 3 4 5 6 7 8)

ren c number_students


* graphing the total number of students by class, gender and # of students who failed
bysort class: egen total_students_class = total(number_students)
* graph twoway bar total_students_class class 

bysort sex: egen total_students_sex = total(number_students)
*graph twoway bar total_students_sex sex, ytitle("Number of Students") yscale(range(0 4000000)) ylabel(0(1000000)4000000) ///
*xtitle("Gender") xtick(1 2) xlabel(1 "Male" 2 "Female") 


bysort class sex: egen total_students_class_sex = total(number_students) 

bysort class sex: egen total_students_class_male = total(number_students) if sex ==1
bysort class sex: egen total_students_class_female = total(number_students) if sex ==2

graph twoway (bar total_students_class_male class, xtitle("Current Class of Enrollment") xlabel(1(1)8) ///
ytitle("Number of Students") yscale(range(0 550000)) ylabel(0(100000)550000)) ///
(bar total_students_class_female class,  xtitle("Current Class of Enrollment") xlabel(1(1)8) ///
ytitle("Number of Students") yscale(range(0 550000)) ylabel(0(100000)550000) ///
fcolor(none) lcolor(black)), legend(label(1 "Total Male Students" 2 "Total Female Students")) 

egen total_students_rural = total(number_students) if rururb == 1
egen total_students_urban = total(number_students) if rururb == 2

bysort class: egen total_students_class_rural = total(number_students) if rururb == 1
bysort class: egen total_students_class_urban = total(number_students) if rururb == 2

*graph twoway bar total_students_class_rural class, xtitle("Current Class of Enrollment") xlabel(1(1)8) ///
*ytitle("Number of Students") 

*graph twoway bar total_students_class_urban class ,  xtitle("Current Class of Enrollment") xlabel(1(1)8) ///
*ytitle("Number of Students") 



egen total_students_assamese = total(number_students) if medinstr1 == 1
egen total_students_bengali = total(number_students) if medinstr1 == 2
egen total_students_gujarati = total(number_students) if medinstr1 == 3
egen total_students_hindi = total(number_students) if medinstr1 == 4
egen total_students_kashmiri = total(number_students) if medinstr1 == 6
egen total_students_odia = total(number_students) if medinstr1 == 12
egen total_students_sanskrit = total(number_students) if medinstr1 == 14
egen total_students_urdu = total(number_students) if medinstr1 == 18
egen total_students_english = total(number_students) if medinstr1 == 19
egen total_students_bodo = total(number_students) if medinstr1 == 20
egen total_students_other = total(number_students) if medinstr1 == 99 | medinstr1  == 34 | medinstr1 == 98


bysort class: egen total_students_class_assamese = total(number_students) if medinstr1 == 1
bysort class: egen total_students_class_bengali = total(number_students) if medinstr1 == 2
bysort class: egen total_students_class_gujarati = total(number_students) if medinstr1 == 3
bysort class: egen total_students_class_hindi = total(number_students) if medinstr1 == 4
bysort class: egen total_students_class_kashmiri = total(number_students) if medinstr1 == 6
bysort class: egen total_students_class_odia = total(number_students) if medinstr1 == 12
bysort class: egen total_students_class_sanskrit = total(number_students) if medinstr1 == 14
bysort class: egen total_students_class_urdu = total(number_students) if medinstr1 == 18
bysort class: egen total_students_class_english = total(number_students) if medinstr1 == 19
bysort class: egen total_students_class_bodo = total(number_students) if medinstr1 == 20
bysort class: egen total_students_class_other = total(number_students) if medinstr1 == 99 | medinstr1  == 34 | medinstr1 == 98


bysort dist_number: egen total_students_dist = total(number_students)


keep if dist_number == 1 | dist_number == 2 | dist_number == 3 | dist_number == 4 | dist_number == 5 | dist_number == 6 | dist_number == 7 | ///
		dist_number == 8 | dist_number == 9 | dist_number == 10 | dist_number == 13 | dist_number == 15 | dist_number == 16 | dist_number == 17 | ///
 		dist_number == 18 | dist_number == 19  | dist_number == 21 | dist_number == 22
 		


tempfile reshaped_data
save `reshaped_data'


*** Mapping using Jharkhand admin shapefiles

* Converting shapefiles to .dta -- only need to do this once 
* shp2dta converts the shapefile to 2 dta files
*shp2dta using "/Users/amanbirs/Dropbox/WB adolescent girls project/jharkhand_administrative_shapefiles/jharkhand_administrative.shp", ///
*data("/Users/amanbirs/Dropbox/WB adolescent girls project/jharkhand_administrative_shapefiles/jharkhand_administrative_db") ///
*coor("/Users/amanbirs/Dropbox/WB adolescent girls project/jharkhand_administrative_shapefiles/jharkhand_administrative_coor")


use "/Users/amanbirs/Dropbox/WB adolescent girls project/jharkhand_administrative_shapefiles/jharkhand_administrative_db", clear
ren NAME distname

** The shapefile includes many districts from neighbouring states. These are being dropped.

keep if _ID == 3 | _ID == 7 | _ID == 13 | _ID == 16 | _ID == 17 | _ID == 22 | _ID == 28 | _ID == 32 | ///
_ID == 12 | _ID == 10 | _ID == 14 | _ID == 15 | _ID == 29 | _ID == 34 | _ID == 35 | _ID == 45 | /// 
_ID == 42 | _ID == 46 


*  Data is missing in the shapefile for these districts -- not included in 2011 census (created later)
/*
Latehar
Ramgarh
Simdega
Khunti
Saraikela Kharsawan
Jamtara
*/




drop if distname == ""
replace distname = upper(distname)

replace distname = "HAZARIBAG" if distname == "HAZARIBAGH"
replace distname = "PASHCHIMI SINGHBHUM" if distname == "SINGHBHUM"

sort distname


merge 1:m distname using `reshaped_data'



*drop if _merge == 1

* contracting to district level variables
contract distname ADMIN_LEVE _ID dist_number total_students_dist
ren _freq total_schools_dist


spmap total_students_dist using "/Users/amanbirs/Dropbox/WB adolescent girls project/jharkhand_administrative_shapefiles/jharkhand_administrative_coor", id(_ID) fcolor(Blues) legend(off)


** Generating Variables for number of children failing

