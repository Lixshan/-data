use "carbon_tax.dta", clear

// 初始化迴圈和變數
local response willing_pay // 被解釋變數
local predictors en_all ct_living_cost ct_necessary ct_resonable ct_spe_willing tax_cut_poor tax_spe_use tax_spe_willing tax_transparency tax_use_poor i.ct_sort1 i.tax_use_sort1 // 變數
local selected "female" // 基本模型，無則""
local min_bic = 1e+10  // 很大的數字
local change 1  // 初始化 change 所以必定可以進入迴圈

// 逐步前進選擇法
while `change' {

    local change 0  // 重設 change. 這不是最好寫法，但我們解決不了另一種寫法導致的錯誤
	
    foreach var of local predictors {
        // 試著添加每個候選變數到模型中
        quietly reg `response' `selected' `var'
		quietly estat ic
		local current_bic = r(S)[1,6]
        
        // 檢查是否有改善
        if `current_bic' < `min_bic' {
            local min_bic = `current_bic'
            local best_var = "`var'"
            local change 1  // Set change to 1 to indicate improvement and continue the loop
        }
		
	// display "min_bic: `min_bic'"
	// display "best_var: `best_var'"
	// display "var: `var'"
	
    }

    // 更新所選變數
    if `change' {
        local selected "`selected' `best_var'" 
		local predictors = subinstr("`predictors'", "`best_var'", "", .)
		// display "predictors: `predictors'"
        display "Added `best_var', new model: `response' ~ `selected'"
		
    }
}

// 顯示最終模型
display "`selected'"
display "Final model: `response' ~ `selected'"
reg `response' `selected'
estat ic