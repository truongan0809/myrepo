********************************************************************
********************************************************************
**********************Author: Tevin Tafese, 22.09.2019**************
********************************************************************
/*
	GENERAL STEPS:

version 14              // Set Version number for backward compatibility
set more off, permanently   // Disable partitioned output
set linesize 80         // Line size limit to make output more readable
macro drop _all         // clear all macros
capture log close       // Close existing log files
set scrollbufsize 300000
set maxvar 32767

*Path
global dir `"C:\Users\\`c(okyou)'\Dropbox\Promotion\Vietnam Project\Misallocation SME Vietnam"'
global workpath "$dir\Dofiles\Auxfiles"
global rdatapathemp "$dir\Data\Raw Data\Employee data"
global cdatapathemp "$dir\Data\Cleaned Data\Employee data"
global rdatapathenter "$dir\Data\Raw Data\Enterprise data"
global cdatapathenter "$dir\Data\Cleaned Data\Enterprise data"
global tables "$dir\Tables"
global figures "$dir\Figures"
global paper "$dir\Paper Latex"

*/
********************************************************************************
**********************Units of Quantities***************************************
********************************************************************************
use "C:\Users\ttafe\Dropbox\Promotion\Vietnam Project\Misallocation SME Vietnam\Data\Cleaned Data\Enterprise Data\temp", clear

/*
preserve
*label drop isic4
keep if isic4==1071 | isic4==1074 | isic4==1079 | isic4==1410 | isic4==1622  | isic4==1629 | isic4==2220 | isic4==2592 | isic4==2599 | isic4==3100 

#delimit; 
keep year id lsal sal lva va lcap cap lemp emp linv inv linv_rd inv_rd mat 
lmat sector isic4 formal leasetyp prodname1 prodname1 prodname2 prodname3 
sic1 sic2 sic3 unit1 unit2 unit3 qprod1 qprod2 qprod3 qsal1 qsal2 qsal3 price1 
price2 price3 cost1 cost2 cost3;
#delimit cr 

tab isic4, gen(isic4)	// industry dummies

#delimit; 
label def isic4 1071 "Manufacture of bakery products" 1074 "Manufacture of macaroni" 
1079 "Manufacture of other food products" 1410 "Manufacture of wearing apparel"  
1622 "Manufacture of builders' carpentry"  1629 "Manufacture of other products of wood" 
2220 "Manufacture of plastic products" 2592 "Treatment and coating of metals" 
2599 "Manufacture of other fabricated metal products" 3100 "Manufacture of furniture";
#delimit cr

label val isic4 isic4
format sector leasetype isic4 %30.0g

br id year isic4 sic1 sic2 sic3 unit1 unit2 unit3 qprod1 qprod2 qprod3 qsal1 qsal2 qsal3 price1 price2 price3 cost1 cost2 cost3 


gen unit1_s=unit1 

/*Isic 1071, Bakery products*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==1071

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" )) & isic4==1071
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1071
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1071
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1071
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n")) & isic4==1071
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000")) & isic4==1071
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 ")) & isic4==1071
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1071 

br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Tonnes" & unit1_s!="Bags" & isic4==1071
gen mark= regexm(unit1_s,"..") & isic4==1071 & year!=2009
replace mark=. if (year==2009 & isic4==1071) | isic4!=1071
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s sal if mark==0 //Except for ids 2267, 2272 and 158 all firms did sell in pieces
replace unit1_s="Pieces" if mark==0 & id!=2267 & id!=2272 & id!=158
drop mark 

br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if unit1_s!="Pieces" & unit1_s!="Liter" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Tonnes" & unit1_s!="Bags" & isic4==1071

/*Isic 1074, Macaroni*/

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" )) & isic4==1074
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1074
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1074
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1074
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==1074
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000")) & isic4==1074
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 ")) & isic4==1074
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 ")) & isic4==1074
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 ")) & isic4==1074
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1074 
replace unit1_s="Ta" if (regexm(unit1_s, "t.$")) & isic4==1074



/*Isic 1079, Other food products*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==1079

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" )) & isic4==1079
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1079
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1079
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1079
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==1079
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==1079
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==1079
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==1079
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==1079
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1079 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==1079
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==1079 

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & isic4==1079
; 
#delimit cr

/*Isic 1410, Wearing and apparel*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==1410

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$")) & isic4==1410
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1410
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1410
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1410
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==1410
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==1410
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==1410
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==1410
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==1410
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1410 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==1410
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==1410 

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & isic4==1410
; 
#delimit cr



/*Isic 1622 builders' carpentry*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==1622

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$")) & isic4==1622
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1622
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1622
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1622
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==1622
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==1622
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==1622
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==1622
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==1622
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1622 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==1622
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==1622 
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu")) & isic4==1622
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==1622
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s,"^met$")) & isic4==1622

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==1622
; 
#delimit cr

/*Isic 1629 other products of wood*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==1629

replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i") | regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$")) & isic4==1629
replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==1629
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==1629
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==1629
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==1629
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==1629
replace unit1_s="250 (pieces)" if (regexm(unit1_s, "^b.250$"))& isic4==1629
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==1629
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==1629
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==1629
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==1629 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==1629
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==1629 
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu")) & isic4==1629
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==1629
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s,"^met$")) & isic4==1629

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==1629
; 
#delimit cr

/*Isic 2220 plastic products*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==2220

#delimit; 
replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i")
| regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$") 
| regexm(unit1_s, "^cu.n$") | regexm(unit1_s, "^Cu.n$")) & isic4==2220; 
#delimit cr

replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==2220
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh")) & isic4==2220
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==2220
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==2220
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==2220
replace unit1_s="250 (pieces)" if (regexm(unit1_s, "^b.250$"))& isic4==2220
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==2220
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==2220
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==2220
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==2220 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==2220
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==2220 
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu")) & isic4==2220
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==2220
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s,"^mets$") | regexm(unit1_s, "^m.t$")) & isic4==2220

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==2220
; 
#delimit cr

/*Isic 2592 Treatment and coating of metals*/
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==2592

#delimit; 
replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i")
| regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$") 
| regexm(unit1_s, "^cu.n$") | regexm(unit1_s, "^Cu.n$")| regexm(unit1_s, "^c.y$")) & isic4==2592; 
#delimit cr

replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==2592
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh") | regexm(unit1_s, "th.ng$")) & isic4==2592
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==2592
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==2592
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==2592
replace unit1_s="250 (pieces)" if (regexm(unit1_s, "^b.250$"))& isic4==2592
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==2592
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==2592
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==2592
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==2592 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==2592
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==2592 
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s,"^M2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu")) & isic4==2592
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==2592
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s,"^mets$") | regexm(unit1_s, "^m.t$")) & isic4==2592

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==2592
; 
#delimit cr

/*Isic 2599 other fabricated metal products*/ 

br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==2599

#delimit; 
replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i")
| regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$") 
| regexm(unit1_s, "^cu.n$") | regexm(unit1_s, "^Cu.n$")| regexm(unit1_s, "^c.y$")) & isic4==2599; 
#delimit cr

replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==2599
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh") | regexm(unit1_s, "th.ng$")) & isic4==2599
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==2599
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==2599
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==2599
replace unit1_s="250 (pieces)" if (regexm(unit1_s, "^b.250$"))& isic4==2599
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==2599
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==2599
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==2599
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==2599 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==2599
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==2599 
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s,"^mets$") | regexm(unit1_s, "^m.t$") | regexm(unit1_s, "^1m$")) & isic4==2599
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s,"^M2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu") | regexm(unit1_s, "^dm2")) & isic4==2599
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==2599
replace unit1_s="m4" if (regexm(unit1_s, "^m4$")) & isic4==2599

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==2599
; 
#delimit cr

/*Isic 3100 Manufacture of furniture */
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s if isic4==3100

#delimit; 
replace unit1_s="Pieces" if (regexm(unit1_s,"^ch.*c") | regexm(unit1_s,"^Ch.*c") | regexm(unit1_s,"^c.*i")
| regexm(unit1_s, "^C.*i") | regexm(unit1_s, "^CAI$") | regexm(unit1_s, "^g.i" ) | regexm(unit1_s, "^b.$") | regexm(unit1_s, "^B.$") 
| regexm(unit1_s, "^cu.n$") | regexm(unit1_s, "^Cu.n$")| regexm(unit1_s, "^c.y$")) & isic4==3100; 
#delimit cr

replace unit1_s="Kg" if (regexm(unit1_s,"^k.*g") | regexm(unit1_s,"^K.*g") | regexm(unit1_s, "^K.*G")) & isic4==3100
replace unit1_s="Thang" if (regexm(unit1_s,"^th.*ng") | regexm(unit1_s, "^Th.*ng") | regexm(unit1_s,"^th.*nh") | regexm(unit1_s, "th.ng$")) & isic4==3100
replace unit1_s="Bags" if (regexm(unit1_s, "^t.*i") | regexm(unit1_s, "^T.*i") | regexm(unit1_s, "^b.*ch")) & isic4==3100
replace unit1_s="Tonnes" if (regexm(unit1_s,"^t.*n") | regexm(unit1_s, "^T.*n") | regexm(unit1_s, "^1000 kg")) & isic4==3100
replace unit1_s="Thousands (pieces)" if (regexm(unit1_s, "^1000 c")) & isic4==3100
replace unit1_s="250 (pieces)" if (regexm(unit1_s, "^b.250$"))& isic4==3100
replace unit1_s="Hundreds (pieces)" if (regexm(unit1_s,"^100 c ")) & isic4==3100
replace unit1_s="Fifties (pieces)" if (regexm(unit1_s,"^50 c ")) & isic4==3100
replace unit1_s="Tens (pieces)" if (regexm(unit1_s, "^10 c ")) & isic4==3100
replace unit1_s="Liter" if (regexm(unit1_s, "^l.*t$")) & isic4==3100 
replace unit1_s="Ta" if (regexm(unit1_s, "^t.$")) & isic4==3100
replace unit1_s="Beer" if (regexm(unit1_s,"^b.a$")) & isic4==3100 
replace unit1_s="m" if (regexm(unit1_s, "^m$") | regexm(unit1_s, "^M$") | regexm(unit1_s,"^mets$") | regexm(unit1_s, "^m.t$") | regexm(unit1_s, "^1m$")) & isic4==3100
replace unit1_s="m2" if (regexm(unit1_s, "^m2") | regexm(unit1_s,"^M2") | regexm(unit1_s, "^met vu") | regexm(unit1_s, "^met Vu") | regexm(unit1_s, "^m.t vu") | regexm(unit1_s, "^dm2")) & isic4==3100
replace unit1_s="m3" if (regexm(unit1_s, "^m3")) & isic4==3100
replace unit1_s="m4" if (regexm(unit1_s, "^m4$")) & isic4==3100

#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s 
if unit1_s!="Pieces" & unit1_s!="Kg" & unit1_s!="Thang" & unit1_s!="Bags" & unit1_s!="Tonnes" & 
unit1_s!="Thousands (pieces)" &  unit1_s!="Hundreds (pieces)" & unit1_s!="Fifties (pieces)"
& unit1_s!="Tens (pieces)" & unit1_s!="Liter" & unit1_s!="Ta" & unit1_s!="Beer" & unit1_s!="m2" 
& unit1_s!="m3" & unit1_s!="m" & isic4==3100
; 
#delimit cr

restore

*/
********************************************************************************
***************************All sectors******************************************
********************************************************************************
forv i=1/3{
gen unit`i'_s=unit`i'
} 

br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit1_s unit2_s unit3_s

forv i=1/3{
#delimit; 
replace unit`i'_s="Pieces" if (regexm(unit`i'_s,"^ch.*c") | regexm(unit`i'_s,"^Ch.*c") | regexm(unit`i'_s, "^CHI.C")
| regexm(unit`i'_s,"^c.*i") | regexm(unit`i'_s, "^C.*i") | regexm(unit`i'_s, "^CAI$") | regexm(unit`i'_s, "^g.i" ) 
| regexm(unit`i'_s, "^b.$") | regexm(unit`i'_s, "^B.$") | regexm(unit`i'_s, "^cu.n$") | regexm(unit`i'_s, "^Cu.n$")
| regexm(unit`i'_s, "^c.y$")| regexm(unit`i'_s,"^con$") | regexm(unit`i'_s, "^c.i$") | regexm(unit`i'_s, "^b.c") 
| regexm(unit`i'_s, "^c$") | regexm(unit`i'_s, "^doi$") | regexm(unit`i'_s,"^mi.ng") | regexm(unit`i'_s, "^mieeng$")
| regexm(unit`i'_s, "'c.i") | regexm(unit`i'_s, "pho") | regexm(unit`i'_s, "vi..*n") | regexm(unit`i'_s, "^h.$")); 
#delimit cr

replace unit`i'_s="Thousands (pieces)" if (regexm(unit`i'_s, "^1000 c") | regexm(unit`i'_s, "^1000$") | regexm(unit`i'_s, "^ngh.n c.i$"))
replace unit`i'_s="250 (pieces)" if (regexm(unit`i'_s, "^b.250$"))
replace unit`i'_s="Hundreds (pieces)" if (regexm(unit`i'_s,"^100 c.")) 
replace unit`i'_s="Fifties (pieces)" if (regexm(unit`i'_s,"^50 c.")) 
replace unit`i'_s="Tens (pieces)" if (regexm(unit`i'_s, "^10 c.")) 
replace unit`i'_s="Tenth (pieces)" if (regexm(unit`i'_s, "^0.1 C.i")) 


replace unit`i'_s="Kg" if (regexm(unit`i'_s,"^k.*g") | regexm(unit`i'_s,"^K.*g") | regexm(unit`i'_s, "^K.*G") | regexm(unit`i'_s, "0kg")) 
replace unit`i'_s="Thousands (KG)" if regexm(unit`i'_s, "ngh.n kg") 

replace unit`i'_s="Thang" if (regexm(unit`i'_s,"^th.*ng") | regexm(unit`i'_s, "^Th.*ng") | regexm(unit`i'_s,"^th.*nh") | regexm(unit`i'_s, "th.ng$")) 
replace unit`i'_s="Bags" if (regexm(unit`i'_s, "^t.*i") | regexm(unit`i'_s, "^T.*i") | regexm(unit`i'_s, "^b.*ch") | regexm(unit`i'_s, "^c.p$")) 
replace unit`i'_s="Tonnes" if (regexm(unit`i'_s,"^t.*n") | regexm(unit`i'_s, "^T.*n") | regexm(unit`i'_s, "^1000 kg")) 

replace unit`i'_s="Liter" if (regexm(unit`i'_s, "^l.*t$") | regexm(unit`i'_s, "^L.t$") | regexm(unit`i'_s, "^lits$") | regexm(unit`i'_s, "^l$"))
replace unit`i'_s="Thousands (liter)" if (regexm(unit`i'_s, "^1000l.*") | regexm(unit`i'_s, "^1000 l.t"))

replace unit`i'_s="Ta" if (regexm(unit`i'_s, "^t.$")) 
replace unit`i'_s="Beer" if (regexm(unit`i'_s,"^b.a$"))
replace unit`i'_s="Thousands (Beer)" if (regexm(unit`i'_s, "^1000 b.a") | regexm(unit`i'_s, "^nghin bia$")) 

#delimit;  
replace unit`i'_s="m" if (regexm(unit`i'_s, "^m$") | regexm(unit`i'_s, "^M$") | regexm(unit`i'_s, "M.t$") | 
regexm(unit`i'_s,"^mets$") | regexm(unit`i'_s, "^m.t$") | regexm(unit`i'_s, "^1m$")); 

replace unit`i'_s="m2" if (regexm(unit`i'_s, "^m2") | regexm(unit`i'_s,"^M2") | regexm(unit`i'_s, "m vu.ng") | regexm(unit`i'_s, "^met vu")
| regexm(unit`i'_s, "^met Vu") | regexm(unit`i'_s, "^m.t vu") | regexm(unit`i'_s, "^dm2"));
#delimit cr

replace unit`i'_s="Thousands (m2)" if regexm(unit`i'_s, "^1000m2") | regexm(unit`i'_s, "ngh.n m2")
replace unit`i'_s="m3" if (regexm(unit`i'_s, "^m3") | regexm(unit`i'_s, "^met kh.i")) 
replace unit`i'_s="m4" if (regexm(unit`i'_s, "^m4$")) 
replace unit`i'_s="Sacks" if (regexm(unit`i'_s, "^bao$") | regexm(unit`i'_s, "^Bao$"))
replace unit`i'_s="Jars" if (regexm(unit`i'_s, "^binh*") )
replace unit`i'_s="Gramm" if (regexm(unit`i'_s, "^gam$") | regexm(unit`i'_s,"^gram*") | regexm(unit`i'_s, "^gr$"))
replace unit`i'_s="Canister" if (regexm(unit`i'_s, "b.nh$"))
replace unit`i'_s="Hop" if (regexm(unit`i'_s, "^h.p$"))
replace unit`i'_s="Khoi" if (regexm(unit`i'_s, "^kh.i$") | regexm(unit`i'_s, "^Kh.i$"))

sort unit`i'_s isic4
#delimit;
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit`i'_s 
if unit`i'_s!="Pieces" & unit`i'_s!="Kg" & unit`i'_s!="Thang" & unit`i'_s!="Bags" & unit`i'_s!="Tonnes" & 
unit`i'_s!="Thousands (pieces)" &  unit`i'_s!="Hundreds (pieces)" & unit`i'_s!="Fifties (pieces)"
& unit`i'_s!="Tens (pieces)" & unit`i'_s!="Liter" & unit`i'_s!="Ta" & unit`i'_s!="Beer" 
& unit`i'_s!="Thousands (Beer)" & unit`i'_s!="m" & unit`i'_s!="m2" & unit`i'_s!="m3" 
& unit`i'_s!="m4" & unit`i'_s!="Sacks" & unit`i'_s!="Jars" & unit`i'_s!="Gramm" & unit`i'_s!="Canister" 
& unit`i'_s!="Hop" & unit`i'_s!="Khoi"; 
#delimit cr

gen mark`i'= regexm(unit`i'_s,"..") 
replace mark`i'=. if unit`i'_s=="" | unit`i'_s=="m" | unit`i'_s=="0" | unit`i'_s=="3"
br id year prodname1 isic4 sic1 unit1 qprod1 qsal1 price1 cost1 formal emp unit`i'_s sal mark`i' if mark`i'==0 //Except for ids 2267, 2272 and 158 all firms did sell in pieces
replace unit`i'_s="Pieces" if mark`i'==0 
drop mark`i'
}

keep id year unit*_s
cd "$cdatapathenter"
save units, replace 
