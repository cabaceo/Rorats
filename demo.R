
# https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
# https://api.orats.com/docs/?plaintext#introduction

# A common policy is to retry up to 5 times, starting at 1s, and each time 
# doubling and adding a small amount of jitter (plus or minus up to, say, 5% of 
# the current wait time).


library(dplyr)


# vary
ticker = "AAPL"
chosen_data_path = paste0("volatility/ticker/", ticker) 
half_url = make_half_url("historical", chosen_data_path)

tickers = c("AAPL", "IBM")
chosen_data_path = paste0("coredatas/general/stocklist/", 
                          paste(tickers, collapse = ",")) 
half_url = make_half_url("live", chosen_data_path)

api_path = paste0(half_url, make_user_key())
data = orats_api(api_path)

lst = data$content[[1]]
 
res = lapply(lst, function(sublst) data.frame(sublst, stringsAsFactors = F))
res = do.call("rbind", res) 
str(res)
View(res)
