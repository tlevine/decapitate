library(sqldf)

animals <- sqldf('select * from incidents', dbname = 'animals.db')

# Remove things that are the same for all rows or all but one row.
for (colname in names(animals)) {
  n <- length(unique(animals[,colname]))
  if (n <= 2) {
    animals[,colname] <- NULL
  }
}

# Use the average of date_started and date_closed as the date?
dates <- lapply(animals[c("date_started", "date_closed")], strptime, format = '%m/%d/%Y')
animals$date_started <- animals$date_closed <- animals$resolution_action_updated <- NULL
animals$date <- as.Date(dates$date_started + ((dates$date_closed - dates$date_started) / 2))

names.thing <- c("animal", "quantity", "body_part_found", "complaint_details", "resolution_description")
names.reporting <- c("source", "division")
names.location <- c("park_or_facility", "property_number", "park_district",
                    "additional_location_details", "council_district_number",
                    "site_street_address", "site_borough", "site_city_zip",
                    "lat", "lng")
