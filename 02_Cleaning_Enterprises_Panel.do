********************************************************************
********************************************************************
**********************Author: Tevin Tafese, 27.03.2019**************
********************************************************************

/*
	GENERAL STEPS:
	
	1) Merging 2011-2015 data with 2007-2009 data
	2) Generating variables and renaming
*/


clear all
version 14              // Set Version number for backward compatibility
set more off, permanently   // Disable partitioned output
set linesize 80         // Line size limit to make output more readable
macro drop _all         // clear all macros
capture log close       // Close existing log files
set scrollbufsize 300000
set maxvar 32767

*Path
global dir `"C:\Users\\`c(truongan)'\Dropbox\Promotion\Vietnam Project\Misallocation SME Vietnam"'
global workpath "$dir\Dofiles"
global rdatapathemp "$dir\Data\Raw Data\Employee data"
global cdatapathemp "$dir\Data\Cleaned Data\Employee data"
global rdatapathenter "$dir\Data\Raw Data\Enterprise data"
global cdatapathenter "$dir\Data\Cleaned Data\Enterprise data"
global tables "$dir\Tables"
global figures "$dir\Figures"
global paper "$dir\Paper Latex"

cd "$cdatapathenter"


********************************************************************************
**************************Cleaning Firm-Panel***********************************
********************************************************************************
use Enterprise_Panel, clear
sort q1 year

foreach var of varlist q2b-profitnet_past{
capture noisily replace `var'=. if `var'==98 | `var'==99
}


**********************Identification Pargiculars********************************
replace q3d=. if q3d>1
replace q3e=q3ea if year==2007 | year==2011 | year==2013 


br q7a q7aa year //q7aa is always missing if q7a is no --> replace q7aa with 0
replace q7aa=0 if q7a==0

tab q7b year //Missing for all the firms who said that they have an ENC
replace q7b=1 if q7aa==1
tab q7c year //Missing for all the firms who said under q7aa that they have the ENC
replace q7c=1 if q7aa==1
tab q8 //In 2011 when the owner changed q8 was set to 3. Actually it should be "repeat" as the firm had been in the sample previously
replace q8=1 if year==2011 & q8==3 
replace q9=0 if year==2011 & q9==. //In the cases of no change in the owner q9 was missing
tab q10a year  //Strangely, only for the cases where there was a new entrepreneur this question was asked in 2011 
tab q10b year //Same as before

tab q7b year //Only from 2011 on asked
tab q12b year //Only asked for household enterprises from 2009 on 
tab q132b1_2007 //This variable comprises whether a firm had a business registration certificate in 2007 
replace q12b=q132b1_2007 if q12a==1 & year==2007 //replace for 2007 only 
recode q12b (0=2) if year==2007

/*Don't implement as this would generate implausible values and higher registration in 2007 than 2009 
replace q12b=1 if q132b1_2007==1 & q12a==1 & year==2007 
replace q12b=2 if q132b1_2007==0 & q12a==1 & year==2007 
*/

tab q129b1 year //This one however also asked in 2007; though missing for 2015


******************General Characteristics***************************************

tab q14b year //Confusing data for 2007
tab q14c year
tab q14d year

tab q17a year
tab q17a_4ds year //For 2009 the exact 4-digit ISIC is unfortunately missing --> However data on the 4-digit ISIC of the most important product 32ab1 available that we can substitute for this as it captures the business sector based on the most important product  
br q1 year q17a_4ds q37ab1 //Data on q37ab1 in 2007 missing --> Do the reverse later for 2007
replace q17a_4ds=q37ab1 if year==2009

count
tab q17a //missing sector for a couple of abservations; Some are truly missing cause it is not possible to assign observations to a specific sector; For others I actually know the sector 
replace q17a=6 if q17a_4ds==1629 
replace q17a=11 if q17a_4ds==2220 
replace q17a=14 if q17a_4ds==2511 | q17a_4ds==2911
replace q17a=18 if q17a_4ds==3100 | q17a_4ds==3290 


***************Household Characteristics of the Owner/Manager*******************

replace q18=1 if q18>=1 & q18<=6 & year==2007
replace q18=0 if q18==7 & year==2007

foreach var of varlist q22aa q22ba q22bb q22bc{
replace `var'=`var'/q22a if year==2007 
}
tab q23a year //Missing for 2007


**************Production Characteristics and Technology*************************

replace q28=. if q28==9 //Coding mistake
tab q31a //For 2009 it is only asked whether the equipment is rented or owned
replace q31a=3 if year==2009 //Assume that only a part is rented as this was also the case in most of the other waves


**************************Sales Structure***************************************

/*Comment: Strangely, even though under q17 it says that the firm produced more 
than 1 (ISIC) good, mostly all three goods have have the same unit code*/
replace q36a=. if q36a==7

br q1 year q37ab1 q17a_4ds //Missing for 2007, however, we can replace with the data in q37ab1
replace q37ab1=q17a_4ds if year==2007
replace q37ab2=q17a_4ds if year==2007 & q17==1 //Only replace the missing ISIC code in q37ab2 with the one in q17a_4ds if the firm offered only products in the same ISIC category
replace q37ab3=q17a_4ds if year==2007 & q17==1 //Only replace the missing ISIC code in q37ab2 with the one in q17a_4ds if the firm offered only products in the same ISIC category


br q37aa1 year //Missing for 2009 
tab q37ab1 year 
tab q37ac1 year //Missing for 2009
br q37ad1 year
br q37ae1 year
tab q37af1 year
br q37ag1 year

tab year, sum(q37ad1) //Strangely for 2011 roughly 100-fold quantities were produced 
tab year, sum(q37ae1) //Same for sales

foreach var of varlist q37ad1 q37ad2 q37ad3 q37ae1 q37ae2 q37ae3{
replace `var'=`var'/100 if year==2011
} //Assume that for 2011 units were captured in a different unit

foreach var of varlist q44a q44b q44c q44d q44e q44f q44g{
replace `var'=`var'/100 if year==2007 | year==2009 
} //For 2007 and 2009 given in percentage 

************Indirect Costs, Raw materials and Services**************************

global indirectcost ""q57a" "q57b" "q57c" "q57d" "q57e" "q57f" "q57g" "q57h" "q57i" "q57j" "q57k""
foreach var of global indirectcost{
gen `var'_s=`var'
replace `var'_s=`var'/costi if year!=2009 
replace `var'_s=`var' if year==2009 
} // Generate cost shares of indirect costs  

drop q57a_1 q57b_1 q57c_1 q57d_1 q57e_1 q57f_1 q57g_1 q57h_1 q57i_1 q57j_1 q57k_1 //There were only cost share for 2013

br q57a  year //For 2009 expenditures are wrongly coded as cost share --> Muliply indirect cost by cost share to get the amount
foreach var of global indirectcost{
replace `var'=costi*`var'*1000 if year==2009 
} //In 2009 the total indirect cost are given in million VND, in the other years however in thousands which is why I need to multiply by 1000

drop q57t //This is the same variable as the "costi" one

tab q59a year //no data in 2015
tab q59b year //no data in 2015
tab q59c year //no data in 2015
tab q59d year //no data in 2015 


foreach var of varlist q59a q59b q59c q59d{
replace `var'=`var'/100 if year==2007
}

foreach var of varlist q60a q60b q60c{
replace `var'=`var'*100 if year==2009
} //Again in fractions as opposed to percent for 2009

tab q61a year //Again in fractions as opposed to percent for 2009, same for the other options
tab q61b year //Again in fractions as opposed to percent for 2009, same for the other options
tab q61c year //Again in fractions as opposed to percent for 2009, same for the other options
tab q61d year //Strange, missing for 2009 and wrong things in 2007
tab q61e year //Strange, missing for 2009 and wrong things in 2007

foreach var of varlist q61d q61e{
replace `var'=. if year==2007 | year==2009
}


global procure ""q61a" "q61b" "q61c" "q61d" "q61e" "q61f" "q62a" "q62b" "q62c" "q62d" "q62e" "q62f""
foreach var of global procure{
replace `var'=`var'*100 if year==2009
}

tab year, sum(q63a) //For 2009 in shares for the others in percentag
foreach var of varlist q63a q63b q63c q63d q63e q63f q63g q63h q64b{
replace `var'=`var'*100 if year==2009 
}

tab q68a1 year //Wrongly coded for 2015
recode q68a1 (7=8) (8=7) if year==2015

replace q69b1=. if q69b1==0

tab q70_ year //Missing for 2007 and 2009 
tab q70 year //it is here in 2007 and 2009 
replace q70=q70_ if year!=2007 & year!=2009  
drop q70_

**************Investments, Assets, Liabilities and Credit***********************

br q1 year q70a //in 2009 the investments are given as the share in total revenue and in 2007 they are in thousands but in the other years in millions--> Hence, I need to multiply with the total revenue "sal" (Actually for 2009 this is given in nominal and in real values; For now I will take the nominal one)

global inv ""q70a" "q70aa" "q70ab" "q70ac" "q70ad" "q70ae" "q70af" "q70ag" "q70ah" "q70ao""

foreach var of global inv{
gen `var'_s=`var'
replace `var'_s=`var'/sal if year!=2009 
replace `var'_s=`var' if year==2009 
} // Generate cost shares of indirect costs  

foreach var of global inv{
replace `var'=`var'*sal if year==2009 
replace `var'=`var'/1000 if year==2007
} //In 2009 the total indirect cost are given in million VND, in the other year however in thousands, but the q70* variables in millions again for 2007 and 2009  

tab q71b1 year //Given in share in 2009 and percentage in all other waves
foreach var of varlist q71b1 q71b2 q71b3 q71b4 q71b5 q71b6{
replace `var'=`var'*100 if year==2009
}


br q73a year //total physical assets for 2007 and the share of physical assets of total assets in 2009 --> Not necassary
drop q73a 

br q1 year q73aa q73ab q73ac q73ad q73ae q73af year //For 2009 again as the share of total assets 
 
global assets ""q73aa" "q73ab" "q73ac" "q73ad" "q73ae" "q73af""
foreach var of global assets{
replace `var'=`var'*phyass if year==2009 //Not multiply by 1000 in this case because the value of the single assets is given in million
replace `var'=`var'/1000 if year==2007 //For 2007 the value is given in thousands, so I need to divide by 1000 to have the values consistend in millions
}

tab year, sum(q73ba) //Missing for 2009 and in thousands for 2007 the rest in millions however 
tab year, sum(q73bb) //same here
foreach var of varlist q73ba q73bb{
replace `var'=`var'/1000 if year==2007
}

tab q74 year //Question does not exist for 2015 
replace q74=. if year==2015

tab q75a year //Missing for 2012. Not possible to distinguish between formal and formal debt for that year. 

br q76 q76a year //For both given as share of total assets for 2009 

foreach var of varlist q76 q76a{
replace `var'=`var'*asstot*1000 if year==2009
} //asstot in millions wheras in thousands for the other years 



******************Fees, Taxes and Informal Costs********************************
replace q95=. if q95==9 
tab q96aa //For 2009 again as the share of total tax
foreach var of varlist q96aa q96ab q96ac q96ad q96ae q96af q96ag{
replace `var'=`var'*fees if year==2009 
replace `var'=`var'/1000 if year==2007
} 

tab q97a year //Missing for 2009 
tab q97a year //two strange values, 305 and 590, for 2007--> replace with missing
replace q97a=. if (q97a==305 | q97a==590) & year==2007 


******************************Employments***************************************

sort q1 year 
br q1 year q101a1 q101a2 q101a3 q101a4 q101a5
tab q101a1 
tab q101a2 //For all years, except for 2007 with respect to q101a*, the share is measured
foreach var of varlist q101a2 q101a3 q101a4 q101a5 q101b{
replace `var'=`var'/q101a1 if year==2007
}

br q1 year q102ta q102tb q102tc q102td q102te q102tf q102tg //For 2009 the sahre is in the total labor force is given, whereas for the other years to number of workers is given

foreach var of varlist q102ta q102tb q102tc q102td q102te q102tf q102tg{
replace `var'=q101a1*`var' if year==2009 
replace `var'=round(`var')
}

tab year, sum(q101da) //Misleading as firms who have no employees have a "0" insted of a missing 
foreach var of varlist q101da q101db q101dc q101dd{
replace `var'=. if `var'==0 
} 

br q1 year q101da q101db q101dc q101dd //Strangely, these figures often don't add up to 100% for firms because there are misssing value for observations

br q1 year q103b q103bb q103bc q103bd q103be q103bf q103bg if q103b!=. //Strangly, often the reasons for workers leaving do not add to the overall number of workers leaving
br q1 year q103b q103bb q103bc q103bd q103be q103bf q103bg if (q103b==. | q103b==0) & ((q103bb!=. & q103bb!=0) | (q103bc!=. & q103bc!=0) | (q103bd!=. & q103bd!=0) | (q103be!=. & q103be!=0) | (q103bf!=. & q103bf!=0) | (q103bg!=. & q103bg!=0))
replace q103b=0 if q103b==.  
foreach var of varlist q103bb q103bc q103bd q103be q103bf q103bg{
replace `var'=0 if `var'==.  | q103b==0
}
tab year, sum(q103bb)
tab q103bb year //in fractions for 2009 

foreach var of varlist q103bb q103bc q103bd q103be q103bf q103bg{
replace `var'=`var'*q103b if year==2009 
}

tab q108 year //In 2009 and 2011, for firms that did not recruit the value is "99"
replace q108=3 if q108==. 

tab q109a year //Same as above 
replace q109a=98 if q109a==99 

tab q109b year //No information for 2007 and 2009
tab q109c year
tab q109d year
tab q109e year //No data for 2007
tab q109f year //No data for 2007
foreach var of varlist q109e q109f{
replace `var'=. if year==2007
}

tab q110a year 

tab q110ba year 

tab q110bb year
replace q110bb=. if q110bb==8

br q1 year q111ab if q111a==1 //In percentage instead of share for 2007
replace q111ab=q111ab/100 if year==2007

foreach var of varlist q112a q112b q112c q112d{
tab `var' year
replace `var'=. if `var'==8 | `var'==98
}

foreach var of varlist q113ab1 q113ab2 q113ab3 q113ab4 q113ab5 q113ab6{
tab `var' year
replace `var'=. if `var'==8 | `var'==98
}

tab q114 year //Only observations for 2013 and 2015
tab q114b year //Only observations for 2007-2011
replace q114=q114b if year>=2007 & year<=2011


*****************Economic Constraints and Potentials****************************

tab q120a year 

foreach var of varlist q120aa q120ab q120ac q120ad q120ae q120af{
tab `var' year
replace `var'=. if `var'==9 
} //Data missing for 2011; and for q120ab the years 2007 and 2009 are separate because the refered to private firms in general without the distinction between formal and informal ones

tab q120ab_0709 year 

tab q121a year 
replace q121a=.  if q121a==99

tab q122 year
tab q122a year


tab q126a year //For 2015 there was an additional category "Lack of quality roads" under 15 --> leave it as it is under recode under "other" and recode 16 to "other" as well
recode q126a (16=15) if year==2015
replace q126a=98 if q126a==99 

br q1 year q131a 

tab q139a year //wrongly coded for 2007 
tab q140a year //same here

foreach var of varlist q139a q139b q139c q139d q139e q140a q140b q140c q140d q140e{
replace `var'=2 if `var'==0 & year==2007 
}



**************************Economic Accounts*************************************

/*Comment: In 2015, the information in the economic accounts is fairly different from the other years*/

br q1 year sal valprod valaddinc costi costraw mat va costlab costlaboth costlabinsur costlabhealth costlabtrain costlabunemp labtot profit depr intp fees invfina invfinb invrawa invrawb phyass land build machin finass asstot debt equity emp imp exp expshare

global account ""sal" "valprod" "valaddinc" "costi" "costraw" "va" "costlab" "costlaboth" "costlabinsur" "costlabhealth" "costlabtrain" "costlabunemp" "profit" "intp" "depr" "fees" "invfina" "invfinb" "invrawa" "invrawb" "phyass" "land" "build" "machin" "finass" "debt" "imp" "exp""

foreach var of global account{
replace `var'=`var'*1000 if year==2009
replace `var'_past=`var'_past*1000 if year==2009 
} //In 2009 the values were given in millions as opposed to thousands in the remaining years

replace mat=costi+costraw if year!=2015
replace labtot=costlab+costlaboth if year!=2015
replace asstot=q73aa+q73ab+q73ac+q73ad+q73ae+q73af if year!=2015


**************************Monetary Units****************************************
*Change all values so that they are given in thousands
foreach var of varlist q70a q70aa q70ab q70ac q70ad q70ae q70af q70ag q70ao q73aa ///
q73ab q73ac q73ad q73ae q73af q73b q73ba q73bb q96aa q96ab q96ac q96ad q96ae q96af q96ag{
replace `var'= `var'*1000
} 

foreach var of varlist q16bb q16c{
replace `var'=`var'*1000 if year!=2007 //Except for 2007, all values are in millions  
}

***************************Drop Duplicates**************************************
duplicates tag q1 year, gen(dupli)
tab dupli //Two IDs for which there are two observations 
br if dupli==1 //Strangely, these are actually two different observations and not just a copy of the same

br if (q1==4720 | q1==4723) //Investigating the subsquent years for 4723, the observation in 2007 with q2d=39 seems to be a different ID; for 4270, the observation with q2d==29 is dropped based on the observation in 2005

drop if q1==4723 & year==2007 & q2d==39 
drop if q1==4720 & year==2007 & q2d==29



********************************************************************************
*************Merging Workers Panel into the Enterprise Panel********************
********************************************************************************
rename q1 id //For merging with worker panel*/

merge 1:m id year using "C:\Users\ttafe\Dropbox\Promotion\Vietnam Project\Misallocation SME Vietnam\Data\Cleaned Data\Employee Data\Employee_Panel_cleaned"
drop if _merge==2 //Strangely there are 39 observations of workers who were surveyed in a year in which the respective firm was not surveyed
drop _merge 
drop wid_old wid_past wid_unique 
foreach var of varlist eqd5-eqe4_2011{
rename `var' `var'_
} //To have see better seperation for different workers
replace wid=0 if wid==. //Necessary for reshaping 
reshape wide eqd5_-eqe4_2011_, i(id year) j(wid)
drop eqd5_0-eqe4_2011_0 
order id year q2b-q70ao_s

save Enterprise_Panel_cleaned, replace 


