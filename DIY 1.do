xxx amsterdam
fff
gen a2dum=a2==2 & a2<.

browse

tab a2dum
count if a2==1
count if a2==2
count if a2==3

list if a2!=1 & a2!=2
list a2 if a2!=1 & a2!=2

drop a2dum1
gen a2dum1=a2==1 & a2!=. & a2!=3
tab a2dum1
tab a2dum


*how to make a dummy of male and female from var that has other sexes

gen a2dum=0 if a2==1
* wrong => gen a2dum=1 if a2==2
replace a2dum=1 if a2==2
tab a2dum

label var a2dum "gioi tinh (nam vs nu)"
label define gtinh 0 "nam" 1 "nu"
label values a2dum gtinh

*check the validity of the new variable
tab a2dum a2, nolabel

