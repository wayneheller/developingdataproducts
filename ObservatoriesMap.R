library(leaflet)


makeHref <-function(url, lnk) {
        wikipediaUrl <- "http://en.wikipedia.org"
        href <- paste0("<a href='", wikipediaUrl, url, "'>", lnk, "</a>")
        return(href)
}
dfObservatories <- read.csv("observatories.csv")
my_map <- leaflet() %>% addTiles()
my_map <- my_map %>% addMarkers(lat=dfObservatories$latitude, lng=dfObservatories$longitude,
                                popup=apply(dfObservatories[,c('url','link')], 1, function(x) makeHref(x[1],x[2])),
                                clusterOptions = markerClusterOptions())
        
my_map


