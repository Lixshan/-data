use "carbon_tax.dta", clear
*安裝輸出
*ssc install estout




***anova檢定各組別環境意識差異
anova en_all group
reg en_all i.group
*K-S檢定
ksmirnov en_all if group == 0 | group == 1, by(group)
ksmirnov en_all if group == 0 | group == 2, by(group)
ksmirnov en_all if group == 1 | group == 2, by(group)


*基本資料K-S檢定

ksmirnov female if group == 0 | group == 1, by(group)
ksmirnov female if group == 0 | group == 2, by(group)
ksmirnov female if group == 1 | group == 2, by(group)

ksmirnov age if group == 0 | group == 1, by(group)
ksmirnov age if group == 0 | group == 2, by(group)
ksmirnov age if group == 1 | group == 2, by(group)

ksmirnov salary if group == 0 | group == 1, by(group)
ksmirnov salary if group == 0 | group == 2, by(group)
ksmirnov salary if group == 1 | group == 2, by(group)

ksmirnov edu if group == 0 | group == 1, by(group)
ksmirnov edu if group == 0 | group == 2, by(group)
ksmirnov edu if group == 1 | group == 2, by(group)




***檢定稅金與碳稅的差異
ttest ct_spe_willing = tax_spe_willing




***回歸

***一噸碳願付價格
*基本資料各自回歸檢定
quietly reg willing_pay female
estimates store model_01
estat ic

quietly reg willing_pay female age
estimates store model_02
estat ic

quietly reg willing_pay female age age_square
estimates store model_03
estat ic

quietly reg willing_pay female  i.edu
estimates store model_04
estat ic

quietly reg willing_pay female i.salary
estimates store model_05
estat ic

*輸出
esttab model_01 model_02 model_03 model_04 model_05  using grades_model.rtf, se ar2 aic bic replace

***逐步回歸法
*基本資料
quietly reg willing_pay female en_all
estat ic
estimates store m1

quietly reg willing_pay female en_all ct_resonable
estat ic
estimates store m2

quietly reg willing_pay female en_all ct_resonable ct_living_cost
estat ic
estimates store m3

quietly reg willing_pay female en_all ct_resonable ct_living_cost ct_spe_willing 
estat ic
estimates store m4

quietly reg willing_pay female en_all ct_resonable ct_living_cost ct_spe_willing  i.tax_use_sort1 
estat ic
estimates store m5

*輸出
esttab  m1 m2 m3 m4 m5 using grades_model.rtf, se ar2 aic bic append



***實驗組別

quietly reg willing_pay female en_all ct_resonable ct_living_cost ct_spe_willing  i.tax_use_sort1 
estat ic
estimates store m5

quietly reg willing_pay female en_all ct_resonable ct_living_cost ct_spe_willing i.tax_use_sort1  i.group
estat ic
estimates store m6

quietly reg willing_pay female age age_square i.edu i.salary en_all ct_resonable ct_living_cost ct_spe_willing  i.tax_use_sort1 
estat ic
estimates store m7

quietly reg willing_pay female age age_square i.edu i.salary en_all ct_resonable ct_living_cost ct_spe_willing i.tax_use_sort1  i.group
estat ic
estimates store m8

esttab m5 m6 m7 m8 using grades_model.rtf, se ar2 aic bic append





***月願付價格
*基本資料各自回歸檢定
quietly reg month_pay female
estimates store model_1
estat ic

quietly reg month_pay female age
estimates store model_2
estat ic

quietly reg month_pay female age age_square
estimates store model_3
estat ic
*不加入age age_square變數

quietly reg month_pay female age i.edu
estimates store model_4
estat ic
*不加入i.edu

quietly reg month_pay female age i.salary
estimates store model_5
estat ic
*不加入i.salary

*輸出
esttab model_1 model_2 model_3 model_4 model_5  using grades_model.rtf, se ar2 aic bic append



***逐步回歸法
*基本資料
quietly reg month_pay female age 
estat ic
estimates store model_2

quietly reg month_pay female age en_all 
estat ic
estimates store model_6

quietly reg month_pay female age en_all ct_necessary
estat ic
estimates store model_7

quietly reg month_pay female age en_all ct_necessary tax_spe_willing
estat ic
estimates store model_8

esttab model_2 model_6 model_7 model_8   using grades_model.rtf, se ar2 aic bic append




***實驗組別

quietly reg  month_pay female age en_all ct_necessary tax_spe_willing
estat ic
estimates store model_8

quietly reg  month_pay female age en_all ct_necessary tax_spe_willing i.group
estat ic
estimates store model_9

quietly reg month_pay female age age_square i.edu i.salary en_all ct_necessary tax_spe_willing
estat ic
estimates store model_10

quietly reg month_pay female age age_square i.edu i.salary en_all ct_necessary tax_spe_willing i.group
estat ic
estimates store model_11

esttab model_8 model_9 model_10 model_11  using grades_model.rtf, se ar2 aic bic append








***對數字有邏輯的人
quietly reg  month_pay female if logic_ability == 1
estat ic

quietly reg  month_pay female  en_all if logic_ability == 1
estat ic

quietly reg  month_pay female en_all tax_spe_use if logic_ability == 1
estat ic





***迴歸

quietly reg  month_pay female en_all tax_spe_use if logic_ability == 1
estat ic
estimates store model_8

quietly reg  month_pay female en_all tax_spe_use i.group if logic_ability == 1 
estat ic
estimates store model_9

quietly reg month_pay female age age_square i.edu i.salary en_all tax_spe_use  if logic_ability == 1 
estimates store model_10

quietly reg month_pay female age age_square i.edu i.salary en_all tax_spe_use i.group if logic_ability == 1 
estat ic
estimates store model_11

esttab model_8 model_9 model_10 model_11  using grades_model.rtf, se ar2 aic bic append




***AIC BIC比較

quietly reg std_willing_pay x0
estat ic
estimates store m001

quietly reg std_month_pay x0
estat ic
estimates store m002

quietly reg std_willing_pay  female en_all ct_resonable ct_living_cost ct_spe_willing  i.tax_use_sort1
estat ic
estimates store m003

quietly reg std_month_pay  female age en_all ct_necessary tax_spe_willing
estat ic
estimates store m004

esttab  m001 m002 m003 m004  using grades_model.rtf, se ar2 aic bic append


















