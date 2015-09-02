library(sqldf)

animals <- sqldf('select * from incidents', dbname = 'animals.db')
# Remove things that are the same for all rows.
animals$date_closed <- animals$status <- animals$priority <-
  animals$form <- animals$location_type <- NULL
