# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'date'

DAYS = 14
FOURTEEN_DAYS_AGO = Date.today - DAYS
SLEEP_START_HOUR = 22

(2..10).each do |id|
  (FOURTEEN_DAYS_AGO..Date.today).each do |date|
    sleep_duration_minutes = rand(300..540)
    sleep_start_time = date.to_datetime + SLEEP_START_HOUR.hours + rand(0..180).minutes
    Sleep.create(
      user_id: id,
      sleep_start_time: sleep_start_time,
      sleep_end_time: sleep_start_time + sleep_duration_minutes.minutes,
      duration_minutes: sleep_duration_minutes
    )
  end
end

