library(leaflet)


makeHref <-function(url, lnk) {
        wikipediaUrl <- "http://en.wikipedia.org"
        href <- paste0("<a href='", wikipediaUrl, url, "'>", lnk, "</a>")
        return(href)
}
dfObservatories <- read.csv("observatories.csv")
dfObservatories_filtered <- dfObservatories[dfObservatories$isNotObservatory == FALSE, ]
vect_popup_links_filtered <- unname(apply(dfObservatories_filtered[,c('url','link')], 1, function(x) makeHref(x[1],x[2])))


my_map <- leaflet() %>% addTiles()
my_map <- my_map %>% addMarkers(lat=dfObservatories_filtered$latitude, lng=dfObservatories_filtered$longitude,
                                popup=vect_popup_links_filtered,
                                clusterOptions = markerClusterOptions())
        
my_map


