library(dplyr)

dfFlightData <- NULL
for(i in 1:13){
        f.path <- file.path(getwd(), paste0("902002334_T_ONTIME ","(", as.character(i),")"), "902002334_T_ONTIME.csv")
        dfFlights <- read.csv(f.path)
        if(is.data.frame(dfFlightData)){
                dfFlightData <- rbind(dfFlights, dfFlightData)
        }
        else {
                dfFlightData <- dfFlights
        }
}

dfAirlines <- read.csv("L_AIRLINE_ID.csv")
names(dfAirlines) <- c("AIRLINE_ID", "AIRLINE_NAME")

dfFlightData <- merge(dfFlightData, dfAirlines, by.x = "AIRLINE_ID", by.y = "AIRLINE_ID")
dfFlightData <- dfFlightData %>% select(MONTH, DAY_OF_WEEK, AIRLINE_NAME, FL_NUM, ORIGIN_CITY_NAME, DEST_CITY_NAME, ARR_DELAY_NEW, CANCELLED)
dfFlightSummary <- dfFlightData %>% group_by(MONTH, DAY_OF_WEEK, AIRLINE_NAME, FL_NUM, ORIGIN_CITY_NAME, DEST_CITY_NAME)
dfFlightSummary <- summarize(dfFlightSummary, avg_delay = round(mean(ARR_DELAY_NEW, na.rm = TRUE),0), pct_cancelled = round(100 * mean(CANCELLED, na.rm = TRUE),0))
write.csv(dfFlightSummary, "FlightSummaryData.csv", row.names = FALSE)

