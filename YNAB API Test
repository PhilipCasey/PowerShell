$accessToken = ""
$budget = curl.exe -H "Authorization: Bearer $accessToken" https://api.ynab.com/v1/budgets | ConvertFrom-Json
$business = $budget.data.budgets | where name -Match Business
$businessID = $business.id
$businessBudget = curl.exe -H "Authorization: Bearer $accessToken" https://api.ynab.com/v1/budgets/$businessID | ConvertFrom-Json
$categories = $businessBudget.data.budget.category_groups | where { ($_.name -NotMatch "Credit Card Payments") -and ($_.name -notmatch "Hidden Categories") -and ($_.name -notmatch "Internal Master Category")} | Select Name, ID
$transactions = curl.exe -H "Authorization: Bearer $accessToken" https://api.ynab.com/v1/budgets/$businessID/transactions | ConvertFrom-Json

$report = @()

ForEach($item in $transactions.data.transactions){

    $report += [PSCustomObject]@{
    Date = $item.date
    PayeeName = $item.payee_name
    Category = $item.category_name
    Amount = $item.amount
    }

}

$cat = $report | where {($_.category -Match "Inflow") -and ($_.payeename -notmatch "Balance") -and ($_.date -match "2024")}

function Get-TotalAmount($cat){
    $total = 0
    foreach($amount in $cat){
        $total += $amount.amount
    }
    $total
}

Get-TotalAmount($cat)
