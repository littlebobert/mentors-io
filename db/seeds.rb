# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

def create_user_and_mentor(input_email)
  email = input_email.nil? ? Faker::Internet.unique.email : input_email
  user = User.create!(email: email, password: "password", name: Faker::Name.unique.name)
  price = (50..1000).to_a.sample

  url = "https://this-person-does-not-exist.com/new?gender=all&age=25-50&etnic=all"
  json = URI.open(url).string
  src = JSON.parse(json)['src']
  photo_url = "https://this-person-does-not-exist.com#{src}"
  file = URI.open(photo_url)
  mentor = Mentor.create!(user: user, specialty: Mentor::SPECIALTIES.sample, price: price)
  mentor.photo.attach(io: file, filename: "user.png", content_type: 'image/png')
  puts "finished creating a user and mentor for: #{email}"
end

puts "starting up"
puts "clearing the db"
Booking.destroy_all
Mentor.destroy_all
User.destroy_all

puts "creating 10 fake users"
10.times do
  create_user_and_mentor
end

puts "creating 3 users for our team"
["riya@gmail.com", "justin.garcia@gmail.com", "shuxingfang@gmail.com"].each do |email|
  create_user_and_mentor(email)
end

Mentor.all.each do |mentor|
  random_user = User.all.excluding(mentor.user).sample
  Booking.create!(user: random_user, mentor: mentor, start_time: rand(4.weeks).seconds.ago)
end

puts "done. generated #{User.count} users and #{Mentor.count} mentors and #{Booking.count} bookings"
