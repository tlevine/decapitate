library(sqldf)

sql <- '
select *,
  count(*),
  min(quantity), max(quantity),
  min(lng), max(lng), min(lat), max(lat)
from i
group by month, round(lng, 5), round(lat, 5)
'
i <- sqldf('select * from incidents', dbname = 'animals.db')
i$month <- strftime(strptime(i$date_started, format = '%m/%d/%Y'), format = '%Y-%m')
animals <- sqldf(sql)

# Remove things that are the same for all rows or all but one row.
for (colname in names(animals)) {
  n <- length(unique(animals[,colname]))
  if (n <= 2 && !grepl('\\(', colname)) {
    animals[,colname] <- NULL
  }
}

# Parse dates.
animals$date_started <- as.Date(strptime(animals$date_started, format = '%m/%d/%Y'))
animals$date_closed <- as.Date(strptime(animals$date_closed, format = '%m/%d/%Y'))

# Use the date_started as the date.
animals$day <- animals$date_started
animals$month <- as.Date(strftime(animals$date_started, '%Y-%m-1'))

# Record how long the case was open for.
animals$case_duration <- difftime(animals$date_closed, animals$date_started, units = 'days')

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
  plot(quantity ~ month, xlab = '', ylab = 'Animal parts found per month',
       data = sqldf('select month, sum(quantity) as \'quantity\' from animals group by month'),
       type = 'l', bty = 'n', main = 'How many animal parts did we find each month?')
}
