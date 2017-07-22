library(dplyr)
dfFlights <- read.csv("902002334_T_ONTIME.csv")
dfAirlines <- read.csv("L_AIRLINE_ID.csv")
names(dfAirlines) <- c("AIRLINE_ID", "AIRLINE_NAME")
dfFlightData <- merge(dfFlights, dfAirlines, by.x = "AIRLINE_ID", by.y = "AIRLINE_ID")
dfFlightData <- dfFlightData %>% select(YEAR, MONTH, DAY_OF_WEEK, AIRLINE_NAME, FL_NUM, ORIGIN_CITY_NAME, DEST_CITY_NAME, ARR_DELAY_NEW, CANCELLED)
dfFlightSummary <- dfFlightData %>% group_by(YEAR, MONTH, DAY_OF_WEEK, AIRLINE_NAME, FL_NUM, ORIGIN_CITY_NAME, DEST_CITY_NAME)
dfFlightSummary <- summarize(dfFlightSummary, avg_delay = mean(ARR_DELAY_NEW, na.rm = TRUE), pct_cancelled = mean(CANCELLED, na.rm = TRUE))
write.csv(dfFlightSummary, "FlightSummaryData.csv", sep=",", row.names = FALSE, append = FALSE)

output$month <- renderUI({