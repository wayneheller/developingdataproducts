library(leaflet)


makeHref <-function(url, lnk) {
        wikipediaUrl <- "http://en.wikipedia.org"
        href <- paste0("<a href='", wikipediaUrl, url, "'>", lnk, "</a>")
        return(href)
}

palette_cols <- c("#0000A0", "#99CC99", "#FFFF99", "#00FF00", "#FFCC66", "#FFFFFF")
domain <- c("Gravitational", "Radio", "Solar", "Microwave", "Neutrino", "Visible")
pal <- colorFactor(palette_cols, domain = domain)
                  
        
dfObservatories <- read.csv("observatories.csv")
dfObservatories_filtered <- dfObservatories[dfObservatories$isNotObservatory == FALSE, ]
vect_popup_links_filtered <- unname(apply(dfObservatories_filtered[,c('url','link')], 1, function(x) makeHref(x[1],x[2])))


my_map <- leaflet() %>% addTiles()
my_map <- my_map %>% addCircleMarkers(lat=dfObservatories_filtered$latitude, lng=dfObservatories_filtered$longitude,
                                popup=vect_popup_links_filtered,
                                radius = 6,
                                color = pal(dfObservatories_filtered$Type),
                                stroke = FALSE,
                                fillOpacity = 0.5,
                                clusterOptions = markerClusterOptions())
        
my_map


#pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))

#leaflet(df) %>% addTiles() %>%
        #addCircleMarkers(
        #        radius = ~ifelse(type == "ship", 6, 10),
        #        color = ~pal(type),
        #        stroke = FALSE, fillOpacity = 0.5

