* COMMENTARY (The RAND Blog)
* Title: Parenting Through the Pandemic: Who's Working, Who's Caring for the Kids, and What Policies Might Help

* This Do file uses a pre-generated data dictionary from IPUMS to format the CPS extract.
* We save a data file--the reformatted January 2020 Basic CPS sample 

* NOTE(S): 
* 1. You need to set the Stata working directory to the path where the data file is located.
* 2. You also need to ensure that the CPS data extract file name reflects the file name of your query (see line 56).

/*
Variables are: 
Type 	Variable 	Label
H 		YEAR 		Survey year
H 		SERIAL 		Household serial number
H 		MONTH 		Month
H 		HWTFINL 	Household weight, Basic Monthly
H 		CPSID 		CPSID, household record
H 		HRHHID 		Household ID, part 1
H 		HRHHID2 	Household ID, part 2
P 		PERNUM 		Person number in sample unit
P 		WTFINL 		Final Basic Weight
P 		CPSIDP 		CPSID, person record
P 		RELATE 		Relationship to household head
P 		AGE 		Age
P 		SEX 		Sex
P 		POPSTAT 	Adult civilian, armed forces, or child
P 		EMPSTAT 	Employment status
P 		LABFORCE 	Labor force status
P 		OCC 		Occupation
*/

local datasource [fill]

set more off

clear
quietly infix                ///
  int     year      1-4      ///
  long    serial    5-9      ///
  byte    month     10-11    ///
  double  hwtfinl   12-21    ///
  double  cpsid     22-35    ///
  double  hrhhid    36-50    ///
  long    hrhhid2   51-56    ///
  byte    pernum    57-58    ///
  double  wtfinl    59-72    ///
  double  cpsidp    73-86    ///
  int     relate    87-90    ///
  byte    age       91-92    ///
  byte    sex       93-93    ///
  byte    popstat   94-94    ///
  byte    empstat   95-96    ///
  byte    labforce  97-97    ///
  int     occ       98-101   ///
  using "`datasource'/cps_00025.dat"

replace hwtfinl  = hwtfinl  / 10000
replace wtfinl   = wtfinl   / 10000

format hwtfinl  %10.4f
format cpsid    %14.0f
format hrhhid   %15.0f
format wtfinl   %14.4f
format cpsidp   %14.0f

label var year     `"Survey year"'
label var serial   `"Household serial number"'
label var month    `"Month"'
label var hwtfinl  `"Household weight, Basic Monthly"'
label var cpsid    `"CPSID, household record"'
label var hrhhid   `"Household ID, part 1"'
label var hrhhid2  `"Household ID, part 2"'
label var pernum   `"Person number in sample unit"'
label var wtfinl   `"Final Basic Weight"'
label var cpsidp   `"CPSID, person record"'
label var relate   `"Relationship to household head"'
label var age      `"Age"'
label var sex      `"Sex"'
label var popstat  `"Adult civilian, armed forces, or child"'
label var empstat  `"Employment status"'
label var labforce `"Labor force status"'
label var occ      `"Occupation"'

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define relate_lbl 0101 `"Head/householder"'
label define relate_lbl 0201 `"Spouse"', add
label define relate_lbl 0202 `"Opposite sex spouse"', add
label define relate_lbl 0203 `"Same sex spouse"', add
label define relate_lbl 0301 `"Child"', add
label define relate_lbl 0303 `"Stepchild"', add
label define relate_lbl 0501 `"Parent"', add
label define relate_lbl 0701 `"Sibling"', add
label define relate_lbl 0901 `"Grandchild"', add
label define relate_lbl 1001 `"Other relatives, n.s."', add
label define relate_lbl 1113 `"Partner/roommate"', add
label define relate_lbl 1114 `"Unmarried partner"', add
label define relate_lbl 1116 `"Opposite sex unmarried partner"', add
label define relate_lbl 1117 `"Same sex unmaried partner"', add
label define relate_lbl 1115 `"Housemate/roomate"', add
label define relate_lbl 1241 `"Roomer/boarder/lodger"', add
label define relate_lbl 1242 `"Foster children"', add
label define relate_lbl 1260 `"Other nonrelatives"', add
label define relate_lbl 9100 `"Armed Forces, relationship unknown"', add
label define relate_lbl 9200 `"Age under 14, relationship unknown"', add
label define relate_lbl 9900 `"Relationship unknown"', add
label define relate_lbl 9999 `"NIU"', add
label values relate relate_lbl

label define age_lbl 00 `"Under 1 year"'
label define age_lbl 01 `"1"', add
label define age_lbl 02 `"2"', add
label define age_lbl 03 `"3"', add
label define age_lbl 04 `"4"', add
label define age_lbl 05 `"5"', add
label define age_lbl 06 `"6"', add
label define age_lbl 07 `"7"', add
label define age_lbl 08 `"8"', add
label define age_lbl 09 `"9"', add
label define age_lbl 10 `"10"', add
label define age_lbl 11 `"11"', add
label define age_lbl 12 `"12"', add
label define age_lbl 13 `"13"', add
label define age_lbl 14 `"14"', add
label define age_lbl 15 `"15"', add
label define age_lbl 16 `"16"', add
label define age_lbl 17 `"17"', add
label define age_lbl 18 `"18"', add
label define age_lbl 19 `"19"', add
label define age_lbl 20 `"20"', add
label define age_lbl 21 `"21"', add
label define age_lbl 22 `"22"', add
label define age_lbl 23 `"23"', add
label define age_lbl 24 `"24"', add
label define age_lbl 25 `"25"', add
label define age_lbl 26 `"26"', add
label define age_lbl 27 `"27"', add
label define age_lbl 28 `"28"', add
label define age_lbl 29 `"29"', add
label define age_lbl 30 `"30"', add
label define age_lbl 31 `"31"', add
label define age_lbl 32 `"32"', add
label define age_lbl 33 `"33"', add
label define age_lbl 34 `"34"', add
label define age_lbl 35 `"35"', add
label define age_lbl 36 `"36"', add
label define age_lbl 37 `"37"', add
label define age_lbl 38 `"38"', add
label define age_lbl 39 `"39"', add
label define age_lbl 40 `"40"', add
label define age_lbl 41 `"41"', add
label define age_lbl 42 `"42"', add
label define age_lbl 43 `"43"', add
label define age_lbl 44 `"44"', add
label define age_lbl 45 `"45"', add
label define age_lbl 46 `"46"', add
label define age_lbl 47 `"47"', add
label define age_lbl 48 `"48"', add
label define age_lbl 49 `"49"', add
label define age_lbl 50 `"50"', add
label define age_lbl 51 `"51"', add
label define age_lbl 52 `"52"', add
label define age_lbl 53 `"53"', add
label define age_lbl 54 `"54"', add
label define age_lbl 55 `"55"', add
label define age_lbl 56 `"56"', add
label define age_lbl 57 `"57"', add
label define age_lbl 58 `"58"', add
label define age_lbl 59 `"59"', add
label define age_lbl 60 `"60"', add
label define age_lbl 61 `"61"', add
label define age_lbl 62 `"62"', add
label define age_lbl 63 `"63"', add
label define age_lbl 64 `"64"', add
label define age_lbl 65 `"65"', add
label define age_lbl 66 `"66"', add
label define age_lbl 67 `"67"', add
label define age_lbl 68 `"68"', add
label define age_lbl 69 `"69"', add
label define age_lbl 70 `"70"', add
label define age_lbl 71 `"71"', add
label define age_lbl 72 `"72"', add
label define age_lbl 73 `"73"', add
label define age_lbl 74 `"74"', add
label define age_lbl 75 `"75"', add
label define age_lbl 76 `"76"', add
label define age_lbl 77 `"77"', add
label define age_lbl 78 `"78"', add
label define age_lbl 79 `"79"', add
label define age_lbl 80 `"80"', add
label define age_lbl 81 `"81"', add
label define age_lbl 82 `"82"', add
label define age_lbl 83 `"83"', add
label define age_lbl 84 `"84"', add
label define age_lbl 85 `"85"', add
label define age_lbl 86 `"86"', add
label define age_lbl 87 `"87"', add
label define age_lbl 88 `"88"', add
label define age_lbl 89 `"89"', add
label define age_lbl 90 `"90 (90+, 1988-2002)"', add
label define age_lbl 91 `"91"', add
label define age_lbl 92 `"92"', add
label define age_lbl 93 `"93"', add
label define age_lbl 94 `"94"', add
label define age_lbl 95 `"95"', add
label define age_lbl 96 `"96"', add
label define age_lbl 97 `"97"', add
label define age_lbl 98 `"98"', add
label define age_lbl 99 `"99+"', add
label values age age_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label define sex_lbl 9 `"NIU"', add
label values sex sex_lbl

label define popstat_lbl 1 `"Adult civilian"'
label define popstat_lbl 2 `"Armed Forces"', add
label define popstat_lbl 3 `"Child"', add
label values popstat popstat_lbl

label define empstat_lbl 00 `"NIU"'
label define empstat_lbl 01 `"Armed Forces"', add
label define empstat_lbl 10 `"At work"', add
label define empstat_lbl 12 `"Has job, not at work last week"', add
label define empstat_lbl 20 `"Unemployed"', add
label define empstat_lbl 21 `"Unemployed, experienced worker"', add
label define empstat_lbl 22 `"Unemployed, new worker"', add
label define empstat_lbl 30 `"Not in labor force"', add
label define empstat_lbl 31 `"NILF, housework"', add
label define empstat_lbl 32 `"NILF, unable to work"', add
label define empstat_lbl 33 `"NILF, school"', add
label define empstat_lbl 34 `"NILF, other"', add
label define empstat_lbl 35 `"NILF, unpaid, lt 15 hours"', add
label define empstat_lbl 36 `"NILF, retired"', add
label values empstat empstat_lbl

label define labforce_lbl 0 `"NIU"'
label define labforce_lbl 1 `"No, not in the labor force"', add
label define labforce_lbl 2 `"Yes, in the labor force"', add
label values labforce labforce_lbl

* Variable Formatting/Labeling 

* Create a unique household identifier from hrhhid and hrhhid2, which together uniquely identify households within basic monthly samples 
* (https://cps.ipums.org/cps-action/variables/HRHHID#description_section)
egen hhid = group(hrhhid hrhhid2)

* Individuals that are unemployed may have a non-zero occupation code, which may
* be indicative of their most recent occupation. To account for this, we recode 
* the occupation variable as unemployed (occ == 0) if the individual's employment
* status states they are unemployment.
replace occ = 0 if empstat != 10 & empstat != 12

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

* For some occupation codes (960, 1541, 1545, 2170, 2180, 2555, 3545, 3550, 3655, 3960, 4160, 4251, 4252, 4255, 4655, 6950, 7640, 8990, 9760, 9840), there was no job group assigned, so we assign it to the closest one.
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

save  "`datasource'/jan2020basic.dta", replace
