library(sqldf)

animals <- sqldf('select * from incidents', dbname = 'animals.db')

# Remove things that are the same for all rows or all but one row.
for (colname in names(animals)) {
  n <- length(unique(animals[,colname]))
  if (n <= 2)
    animals[,colname] <- NULL
}

'
names.thing <- c("animal", "quantity", "body_part_found",
names.date <- c("date_started", "date_closed"
names.reporting <- c("source", "division"
, "status", "complaint_details", "park_or_facility"
[11] "property_number", "park_district", "additional_location_details" "council_district_number", "site_street_address"
[16] "site_borough", "site_city_zip", "lat", "lng", "resolution_action_updated"
[21] "resolution_description", "time_to_action"
'
