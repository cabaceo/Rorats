library(httr)
library(jsonlite)

ua = user_agent("https://github.com/cabaceo/rORATS")

make_half_url = function(data_type = "live", data_chain, api_version = "v2") {
        # data_type  : string of 2 values: "live" or "historical"
        # data_chain : string, specific data path
        # api_version: string, default is "v2"
        if (!data_type %in% c("live", "historical")) 
                stop("The value of data_type can only be 'live' or 'historical'.")
        paste0("/", api_version, "/", data_type, "/", data_chain)
}

make_user_key = function(private_key = "h7mw0t4gxeu6zttt9i87kig8vq6rejy8")
        paste0("?user_key=", private_key)

orats_api = function(api_path) {
        url = modify_url("https://api.orats.com", path = api_path)
        
        resp = GET(url, ua)
        resp_type = http_type(resp)
        
        if (resp_type == "application/json") {
                parsed = jsonlite::fromJSON(content(resp, "text"), 
                                            simplifyVector = F)
        } else {
                stop("API did not return json", call. = FALSE)
        }
        
        if (http_error(resp)) {
                stop(
                        sprintf(
                                "ORATS API request failed [%s]\n%s\n<%s>",
                                status_code(resp),
                                parsed$message,
                                parsed$documentation_url
                        ),
                        call. = FALSE
                )
        }
        
        structure(
                list(content = parsed, 
                     path = path, 
                     response = resp),
                class = "orats_api"
        )
}

print.orats_api = function(x, ...) {
        cat("<ORATS ", x$path, ">\n", sep = "")
        str(x$content)
        invisible(x)
}

