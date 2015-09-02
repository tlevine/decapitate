library(sqldf)

animals <- sqldf('select * from incidents', dbname = 'animals.db')

# Remove things that are the same for all rows or all but one row.
for (colname in names(animals)) {
  n <- length(unique(animals[,colname]))
  if (n <= 2) {
    animals[,colname] <- NULL
  }
}

# Use the date_started as the date.
animals$date_reported <- as.Date(strptime(animals$date_started, format = '%m/%d/%Y'))

# Record how long the case was open for.
animals$case_duration <- difftime(dates$date_closed, dates$date_started, units = 'days')

# Delete date stuff.
animals$date_started <- animals$date_closed <- animals$resolution_action_updated <- NULL

names.thing <- c("animal", "quantity", "body_part_found", "complaint_details", "resolution_description")
names.reporting <- c("source", "division")
names.location <- c("park_or_facility", "property_number", "park_district",
                    "additional_location_details", "council_district_number",
                    "site_street_address", "site_borough", "site_city_zip",
                    "lat", "lng")

explore <- function() {
  plot(table(as.numeric(strftime(animals$date_reported, format = '%W'))),
       xlab = 'Week of the year', ylab = 'Number of decapitated animal reports',
       bty = 'n')
  plot(lng~lat, data = animals, cex = quantity, col = as.numeric((factor(site_borough))))
}
