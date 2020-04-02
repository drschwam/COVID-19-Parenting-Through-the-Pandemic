* American Workers Blog - Workers with Children

* This Do file takes the January 2020 Basic CPS sample formatted in using 
* "AWB CPSdo 3_27 stats QA.do" and generates statistics.

local datasource "/Users/jward/Desktop/Edwards_Wenger_Worker_Blog_CPS_code_review"

* Load the Basic monthly sample (January 2020)
use "`datasource'/jan2020basic.dta", clear

* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *
* According to the definition used below for "non_working_adult" respondents, 
* active-duty military (around 1.5% of sample) are classified as non-working.
tab popstat if occ == 0

* Replace military service members with specific occ code
replace occ = 9800 if popstat == 2

cap drop jobgroup

* Identify job classes from CPS  
gen jobgroup = "Management, Business, Science, and Arts" if occ > 0 & occ <= 950
replace jobgroup = "Computer and Mathematical" if occ >= 1000 & occ <= 1240
replace jobgroup = "Architecture and Engineering" if occ >= 1300 & occ <= 1540
replace jobgroup = "Technicians" if occ >= 1550 & occ <= 1560
replace jobgroup = "Life, Physical, and Social Science" if occ >= 1600 & occ <= 1980
replace jobgroup = "Community and Social Services" if occ >= 2000 & occ <= 2060
replace jobgroup = "Legal" if occ >= 2100 & occ <= 2150
replace jobgroup = "Education, Training, and Library" if occ >= 2200 & occ <= 2550
replace jobgroup = "Arts, Design, Entertainment, Sports, and Media" if occ >= 2600 & occ <= 2920
replace jobgroup = "Healthcare Practitioners and Technical" if occ >= 3000 & occ <= 3540
replace jobgroup = "Healthcare Support" if occ >= 3600 & occ <= 3650
replace jobgroup = "Protective Service" if occ >= 3700 & occ <= 3950
replace jobgroup = "Food Preparation and Serving" if occ >= 4000 & occ <= 4150
replace jobgroup = "Building and Grounds Cleaning and Maintenance" if occ >= 4200 & occ <= 4250
replace jobgroup = "Personal Care and Service" if occ >= 4300 & occ <= 4650
replace jobgroup = "Sales and Related" if occ >= 4700 & occ <= 4965
replace jobgroup = "Office and Administrative Support" if occ >= 5000 & occ <= 5940
replace jobgroup = "Farming, Fishing, and Forestry" if occ >= 6005 & occ <= 6130
replace jobgroup = "Construction" if occ >= 6200 & occ <= 6765
replace jobgroup = "Extraction" if occ >= 6800 & occ <= 6940
replace jobgroup = "Installation, Maintenance, and Repair" if occ >= 7000 & occ <= 7630
replace jobgroup = "Production" if occ >= 7700 & occ <= 8965
replace jobgroup = "Transportation and Material Moving" if occ >= 9000 & occ <= 9750
replace jobgroup = "Military Specific" if occ >= 9800 & occ <= 9830
replace jobgroup = "Unemployed or Never Worked" if occ == 0

* For some occupation codes (960, 1541, 1545, 2170, 2180, 2555, 3545, 3550, 3655, 
* 3960, 4160, 4251, 4252, 4255, 4655, 6950, 7640, 8990, 9760, 9840), there was 
* no job group assigned, so we assign it to the closest one.
replace jobgroup = "Management, Business, Science, and Arts" if occ == 960
replace jobgroup = "Architecture and Engineering" if occ == 1541 | occ == 1545
replace jobgroup = "Legal" if occ == 2170 | occ == 2180
replace jobgroup = "Education, Training, and Library" if occ == 2555
replace jobgroup = "Healthcare Practitioners and Technical" if occ == 3545 | occ == 3550
replace jobgroup = "Healthcare Support" if occ == 3655
replace jobgroup = "Protective Service" if occ == 3960
replace jobgroup = "Food Preparation and Serving" if occ == 4160
replace jobgroup = "Building and Grounds Cleaning and Maintenance" if occ == 4251 | occ == 4252 | occ == 4255
replace jobgroup = "Personal Care and Service" if occ == 4655
replace jobgroup = "Extraction" if occ == 6950
replace jobgroup = "Installation, Maintenance, and Repair" if occ == 7640
replace jobgroup = "Production" if occ == 8990
replace jobgroup = "Transportation and Material Moving" if occ == 9760
replace jobgroup = "Military Specific" if occ == 9840

* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *

* Part 1 - Identify children under 14 and merge them back on to parents, drop other households

* Calculate the number of children under 14 years old. Individuals are labeled 
* as children in the CPS if they are ages 14 and younger. 
* variable popstat: 1 = Adult civilian; 2 = Armed Forces; 3 = Child
gen child_under_14 = (popstat == 3)

preserve
	* Restrict sample to children
	keep if popstat == 3
	
	* Aggregate using person-level weights 
	collapse (sum) child_under_14 [pweight=wtfinl]
	
	* Format display
	format child_under_14 %15.0f
	list child_under_14
restore

* Calculate the number of households with at least 1 child under 14 years old.
preserve
	
	* Collapse data to the household-level. This generates an indicator for each 
	* household that equals 1 if there is at least 1 child under the age of 14 
	* living in that household.
	collapse (max) child_under_14, by(hhid hwtfinl)
	
	* Rename and save indicator so we can identify these households later.
	ren child_under_14 fam_w_child_under_14
	save "`datasource'/hh_child_under_14.dta", replace

	* Now collapse by the indicator just generated using household-level weights
	gen n_households = 1
	collapse (sum) n_households [pweight=hwtfinl], by(fam_w_child_under_14)
	
	* Calculate percent of all households
	egen total_n_households = total(n_households)
	gen pct_of_total = (n_households / total_n_households) * 100

	* Format display
	format * %15.0f
	list 
restore

* Merge on indicator for having at least 1 child under the age of 14 in the hh.
merge m:1 hhid using "`datasource'/hh_child_under_14.dta"
drop _merge

* Drop households without at least 1 child under the age of 14
drop if fam_w_child_under_14 == 0

* Part 2 - Calculate the number of households with at least 1 child under age 14 
* and identify whether there is a non-working adult present.
decode relate, g(relate_str)

preserve
	* First determine if an individual is a "potential parent". By potential parent, 
	* someone that lives in a household and is identified as the head-of-house/householder, 
	* a spouse, or an unmarried partner (do not include "parent" as this likely 
	* means being the parent of the householder, and therefore a grandparent to a child).
	gen potential_parents = inlist(relate_str, "Head/householder", "Opposite sex spouse", "Same sex spouse", "Opposite sex unmarried partner", "Same sex unmaried partner")
	
	* Identify households headed by grandparents as ones where relationship to the head of the household is grandchild.
	gen hh_grandparent = inlist(relate_str, "Grandchild")
	
	* Identify if the household has at least 1 child over the age of 14 
	* (this variable is generated using age since individuals aged 15 and older 
	* are classified as "adult civilians" in the popstat varirable).
	gen fam_w_child_over_14 = (age > 14 & age <= 18)
	
	* Identify if the household has another non-working adult or extended family 
	* member that is over the age of 18.
	gen non_working_adult = (occ == 0 & popstat == 1 & age > 18)

	* Generate indicators by household
	collapse (sum) potential_parents (max) hh_grandparent fam_w_child_over_14 non_working_adult, by(hhid hwtfinl)
	
	* Types of households based on the head-of-house
	gen type_of_hh = "Single_parent" if potential_parents == 1 & hh_grandparent == 0
	replace type_of_hh = "Two_parents" if potential_parents == 2 & hh_grandparent == 0
	replace type_of_hh = "Grandparents" if hh_grandparent == 1
	
	* Any household that does not have a non-working adult and at least 1 child 
	* between the ages of 15 and 19.
	gen remaining = (non_working_adult != 1 & fam_w_child_over_14 != 1)

	* Save so we can use indicators later on
	save "`datasource'/adults_in_hh.dta", replace

	* Aggregate by household type using household weights
	gen n_households = 1
	collapse (sum) n_households fam_w_child_over_14 non_working_adult remaining [pweight=hwtfinl], by(type_of_hh)
	
	* Calculate percent of all households
	egen total_n_households = total(n_households)
	gen pct_of_total = (n_households / total_n_households) * 100
	
	* Format display
	format n_households fam_w_child_over_14 non_working_adult remaining %15.0f
	format total_n_households %15.0f
	list
	
restore

* Merge on info regarding adults in household
merge m:1 hhid using "`datasource'/adults_in_hh.dta", keepusing(type_of_hh remaining)
drop _merge

* Identify parents in each household
gen potential_parents = inlist(relate_str, "Head/householder", "Opposite sex spouse", "Same sex spouse", "Opposite sex unmarried partner", "Same sex unmaried partner")

* Subset to households with no family care options (i.e., no child above the age
* of 14 and/or no non-working adults in the household)
keep if remaining == 1

* Restict to heads of households/potential parents
keep if potential_parents == 1

* Part 3 - Identify if parents of children are earners 
* Identify working- and non-working adults (recall that occ == 0 now accounts for unemployed persons)
gen working_adult = (occ != 0)
gen non_working_adult = (occ == 0) 

preserve
	* Count the number of working heads of households/potential parents
	collapse (sum) working_adult non_working_adult, by(hhid hwtfinl type_of_hh)

	gen no_working_adults = (working_adult == 0)
	gen one_working_adult = (working_adult == 1)
	gen two_working_adults = (working_adult == 2)
	
	* Number of earners in household
	gen earners_in_hh = "zero_earners" if no_working_adults == 1
	replace earners_in_hh = "single_earner" if one_working_adult == 1
	replace earners_in_hh = "dual_earners" if two_working_adults == 1
	
	* Save so we can use indicators later
	save "`datasource'/earners_in_hh.dta", replace

	collapse (sum) no_working_adults one_working_adult two_working_adults [pweight=hwtfinl], by(type_of_hh)

	format *working* %15.0f
	list
restore

* Subset to working adults
keep if working_adult == 1
preserve
	* Occupation distribution (here we are using person weights instead of household weights)
	collapse (sum) working_adult [pweight=wtfinl], by(jobgroup type_of_hh)

	* Reshape to wide
	quietly reshape wide working_adult, i(jobgroup) j(type_of_hh) string

	ren working_adult* *

	* Recode missings as zeros
	foreach var of varlist Grandparents Single_parent Two_parents {
		replace `var' = 0 if `var' == .
		
		* Calulate percent of total
		egen tot`var' = total(`var')
		gen pct_of_`var' = `var' / tot`var'
	}

	keep jobgroup pct_of_*
	ren pct_of_* *
	order jobgroup Single_parent Two_parents Grandparents 
restore

* Occupation distribution of head of household and spouse/partner for dual-earner households
merge m:1 hhid using "`datasource'/earners_in_hh.dta"
drop _merge

* Part 4 - Calculate Occupation Distribution of Parent and Adult Types
* By household type
* Single-parent households
preserve
	keep if type_of_hh == "Single_parent"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (singpar pct_singpar)
	save "`datasource'/occdist_single_parent_hh.dta", replace
restore

* Two-parent households
* Distribution for heads of household
preserve
	keep if type_of_hh == "Two_parents"
	keep if relate_str == "Head/householder"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (twopar_hh pct_twopar_hh)
	save "`datasource'/occdist_two_parent_hh.dta", replace
restore

* Distribution for non-head of household
preserve
	keep if type_of_hh == "Two_parents"
	keep if relate_str != "Head/householder"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (twopar_nhh pct_twopar_nhh)
	save "`datasource'/occdist_two_parent_nhh.dta", replace
restore

* Grandparent-led households
preserve
	keep if type_of_hh == "Grandparents"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (gp pct_gp)
	save "`datasource'/occdist_grandparent_hh.dta", replace
restore

* By earner type
* Single-earner households
preserve
	keep if earners_in_hh == "single_earner"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (singearn pct_singearn)
	save "`datasource'/occdist_single_earner_hh.dta", replace
restore

* Dual-earner households
* Distribution for heads of household
preserve
	keep if earners_in_hh == "dual_earners"
	keep if relate_str == "Head/householder"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (dualearn_hh pct_dualearn_hh)
	save "`datasource'/occdist_dual_earner_hh.dta", replace
restore

* Distribution for non-head of household
preserve
	keep if earners_in_hh == "dual_earners"
	keep if relate_str != "Head/householder"
	gen n = 1
	collapse (sum) n [pweight=hwtfinl], by(jobgroup)
	egen total_n = total(n)
	gen pct_of_total = n / total_n
	drop total_n
	format n %15.0f
	list
	ren (n pct_of_total) (dualearn_nhh pct_dualearn_nhh)
	save "`datasource'/occdist_dual_earner_nhh.dta", replace
restore

* Distribution of all heads of household
* Calculate the occupation distribution only for heads-of-households in the total workforce. 
* We restrict this to heads-of-households only in order to be comparable to the 
* household-level statistics generated earlier. We do not include non-heads-of-households 
* as this would double-count households since each individual in a household has 
* the same household-level weight.
use "`datasource'/Jan2020basic.dta", clear

* Restrict sample to adult civilians in the labor force (i.e., drop children and 
* people in the Armed Forces).
keep if popstat == 1 & labforce == 2

decode relate, g(relate_str)

* Restrict to heads of households
keep if relate_str == "Head/householder"

* Aggregate by occupation group using household-level weights
gen n = 1
collapse (sum) n [pweight=hwtfinl], by(jobgroup)

egen total_adult_pop = total(n)
format n total_adult_pop %15.0f

* Calculate percent of total
gen pct_of_total = n / total_adult_pop

drop total_adult_pop

save "`datasource'/occdist_totalworkforce.dta", replace

* Merge together occupation distribution files
merge 1:1 jobgroup using "`datasource'/occdist_single_parent_hh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_two_parent_hh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_two_parent_nhh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_grandparent_hh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_single_earner_hh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_dual_earner_hh.dta"
drop _merge

merge 1:1 jobgroup using "`datasource'/occdist_dual_earner_nhh.dta"
drop _merge

* Label variables
label var jobgroup "Occupation group"
label var n "Total workforce"
label var pct_of_total "Percent of total workforce"
label var singpar "Single-parent households"
label var pct_singpar "Percent of single-parent households"
label var twopar_hh "Two-parent households - Head of household"
label var pct_twopar_hh "Percent of two-parent households - Head of household"
label var twopar_nhh "Two-parent households - Non-head of household"
label var pct_twopar_nhh "Percent of two-parent households - Non-head of household"
label var gp "Grandparent-led households"
label var pct_gp "Percent of grandparent-led households"
label var singearn "Single-earner households"
label var pct_singearn "Percent of single-earner households"
label var dualearn_hh "Dual-earner households - Head of household"
label var pct_dualearn_hh "Percent of dual-earner households - Head of household"
label var dualearn_nhh "Dual-earner households - Non-head of household"
label var pct_dualearn_nhh "Percent of dual-earner households - Non-head of household"

* Export to excel
preserve
	keep jobgroup n singpar twopar_hh twopar_nhh gp singearn dualearn_hh dualearn_nhh
	export excel "`datasource'/Tables for 3_17_militaryfix.xlsx", sheetreplace sheet("Occ dist - counts") firstrow(varlabels)
restore

preserve
	keep jobgroup pct_of_total pct_singpar pct_twopar_hh pct_twopar_nhh pct_gp pct_singearn pct_dualearn_hh pct_dualearn_nhh
	export excel "`datasource'/Tables for 3_17_militaryfix.xlsx", sheetreplace sheet("Occ dist - percents") firstrow(varlabels)
restore

