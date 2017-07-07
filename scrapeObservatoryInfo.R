# Get list of links in the List of Astronomical Observatories Wikipedia page
# url <- "https://en.wikipedia.org/wiki/Georgian_National_Astrophysical_Observatory"
# Note: Not all links are actual observatories
# Loop through all the links and retrieve its html
# Retrieve latitude and longitude coordinates
# Add latitude and longitude to the dataframe
# Save dataframe as .csv and return dataframe




library(rvest)
#library(measurements)
library(stringr)
setwd("C:/Users/xwhx/Desktop/Coursera/DevelopingDataProducts/developingdataproducts")

# Get all hyperlinks on the list of astronomical observatories page
getLinkstoCheck <- function() {
        url <- "https://en.wikipedia.org/wiki/List_of_astronomical_observatories"
        urls <- url %>%
                read_html() %>%
                html_nodes('a') %>%
                html_attr("href")
        links <- url %>%
                read_html() %>%
                html_nodes('a') %>%
                html_text()
        df <- data.frame(link = links, url = urls, stringsAsFactors = FALSE)
        return(df)
}

# get latitude and longitude from a single observatories page
getGeoCoord <- function(htmlDocument) {
        tryCatch(
                {
                        geo <- xml_text(htmlDocument %>% html_node(xpath='//span[@class= "geo"]'))
                        
                },
                error=function(cond) {
                        message("The coordinates do not seem to exist.")
                        message("Here's the original error message:")
                        message(cond)
                        # Choose a return value in case of error
                        geo <- NA
                },
                warning=function(cond) {
                        message("XPath query caused a warning")
                        message("Here's the original warning message:")
                        message(cond)
                        # Choose a return value in case of warning
                        
                },
                finally = return(geo)
        )
        
}
# No Longer Used  replated with getGeoCoord()
getLatLong <- function(htmlDocument) {
        tryCatch(
                {
                lat <- xml_text(htmlDocument %>% html_node(xpath='//span[contains(@class, "latitude")]'))
                lng <- xml_text(htmlDocument %>% html_node(xpath='//span[contains(@class, "longitude")]'))
                
                },
                error=function(cond) {
                        message("The coordinates do not seem to exist.")
                        message("Here's the original error message:")
                        message(cond)
                        # Choose a return value in case of error
                        lat <- NA; lng <- NA
                },
                warning=function(cond) {
                        message("XPath query caused a warning")
                        message("Here's the original warning message:")
                        message(cond)
                        # Choose a return value in case of warning
                        
                },
                
                finally=return(list(lat, lng))
        )

        }

readPage <- function(urlWikipedia){
        tryCatch(
                {
                        html_page <- NA
                        html_page <- urlWikipedia %>% read_html()
                },
                error=function(cond) {
                        message(paste("URL does not seem to exist:", urlWikipedia))
                        message("Here's the original error message:")
                        message(cond)
                        # Choose a return value in case of error
                        #html_page <- NA
                },
                warning=function(cond) {
                        message(paste("URL caused a warning:", urlWikipedia))
                        message("Here's the original warning message:")
                        message(cond)
                        # Choose a return value in case of warning
                        #html_page <- NA
                },
                finally=return(html_page)
        )
}

getObservatories <- function() {
        # Gets ALL urls on the list of astronomical observatories page
        dfLinks <- getLinkstoCheck()
        
        # Base Wikipedia url
        httpwikipedia <- "http://en.wikipedia.org"
        
        # the first 91 urls are not observatories, loop through the rest until 1664
        for(i in 92:1664) {
             
                url_obs_page <- paste0(httpwikipedia, dfLinks[i, "url"])   
                print(url_obs_page)
                #print(url_obs_page)
                html_obs_page <- readPage(url_obs_page)
                if (!is.na(html_obs_page)) {
                        # If the word "observatory" appears on the page, there is a good chance
                        # it is describing one.  Not perfect, but weeds out the city, state, country links
                        if (grepl("observatory", html_obs_page, ignore.case = TRUE)) {
                                # Get latitude and longitude coordinates
                                coordinates <- getGeoCoord(html_obs_page)
                                if(!is.na(coordinates)){
                                        latlong <- str_split_fixed(coordinates, "; ", 2)
                                        dfLinks[i, "latitude"] <- as.numeric(latlong[1])
                                        dfLinks[i, "longitude"] <- as.numeric(latlong[2])
                                
                                }
                        }
                }
                closeAllConnections()
                        #print("Getting Latitude")
                        #latitude.min.sec <- getLatLong(html_obs_page)[1]
                        #print(getLatLong(html_obs_page))
                        #print("Have Latitude")
                        #if(!is.na(latitude.min.sec)) {
                                #print("Latitude is not NA")
                                #print(latitude.min.sec)
                                #lat <- na.omit(as.character(unlist(strsplit(unlist(latitude.min.sec), "[^0-9]+"))))
                                #lat <- paste(lat, collapse = " ")
                                #latitude.decimal = measurements::conv_unit(lat, from = 'deg_min_sec', to = 'dec_deg')
                        
                                #print(latitude.decimal)
                                #dfLinks[i,"latitude.min.sec"] <- latitude.min.sec
                                #dfLinks[i, "latitude.decimal"] <-  latitude.decimal
                                #}
                        
                        #longitude.min.sec <- getLatLong(html_obs_page)[2]
                        #if(!is.na(longitude.min.sec)){
                                #long <- na.omit(as.character(unlist(strsplit(unlist(longitude.min.sec), "[^0-9]+"))))
                                #long <- paste(long, collapse = " ")
                                #longitude.decimal = measurements::conv_unit(long, from = 'deg_min_sec', to = 'dec_deg')
                        
                                #print(longitude.decimal)
                                #dfLinks[i, "longitude.min.sec"] <- longitude.min.sec
                                #dfLinks[i, "longitude.decimal"] <- longitude.decimal
                                #}
                        
                        
                        
                        
                        
        }
        write.csv(dfLinks[complete.cases(dfLinks), ], "observatories.csv", row.names = FALSE)
        return(dfLinks)
}





