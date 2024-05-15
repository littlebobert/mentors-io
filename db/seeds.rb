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

puts "starting up"
puts "clearing the db"
Booking.destroy_all
Mentor.destroy_all
User.destroy_all

def create_user_and_mentor(specialty, input_email = nil, input_name = nil, input_photo_url = nil)
  name = input_name.nil? ? Faker::Name.unique.name : input_name
  email = input_email.nil? ? Faker::Internet.unique.email : input_email
  user = User.create!(email: email, password: "password", name: name)
  price = (50..1000).to_a.sample

  if input_photo_url.nil?
    url = "https://this-person-does-not-exist.com/new?gender=all&age=35-50&etnic=all"
    json = URI.open(url).string
    src = JSON.parse(json)['src']
    photo_url = "https://this-person-does-not-exist.com#{src}"
  else
    photo_url = input_photo_url
  end
  file = URI.open(photo_url)
  tagline = Faker::Lorem.sentence
  bio = Faker::Lorem.paragraphs(number: 5).join("\n\n")
  mentor = Mentor.create!(user: user, specialty: specialty, price: price, tagline: tagline, bio: bio)
  mentor.photo.attach(io: file, filename: "user.png", content_type: 'image/png')
  puts "finished creating a user and mentor for: #{name}, #{email}"
end

mentors_per_specialty = 8
puts "creating #{Mentor::SPECIALTIES.count * mentors_per_specialty} fake users"
Mentor::SPECIALTIES.each do |specialty|
  mentors_per_specialty.times do
    create_user_and_mentor(specialty)
  end
end

puts "creating 3 users for our team"
team_users = [
  { email: "riyaf3105@gmail.com", name: "Riya Fartyal", photo_url: "https://avatars.githubusercontent.com/u/83643548?v=4" },
  { email: "justin.garcia@gmail.com", name: "Justin Garcia", photo_url: "https://avatars.githubusercontent.com/u/8378384" },
  { email: "fangshuxing0613@gmail.com", name: "Shuxing Fang", photo_url: "https://avatars.githubusercontent.com/u/151457729?v=4" }
]
team_users.each do |hash|
  create_user_and_mentor(Mentor::SPECIALTIES.sample, hash[:email], hash[:name], hash[:photo_url])
end

puts "creating bookings"
Mentor.all.each do |mentor|
  team_users.each do |team_user_hash|
    team_user = User.where(email: team_user_hash[:email]).first
    next if team_user == mentor.user

    Booking.create!(user: team_user, mentor: mentor, start_time: rand(4.weeks).seconds.ago, status: Booking::STATUSES.sample)
  end
end

puts "done. generated #{User.count} users and #{Mentor.count} mentors and #{Booking.count} bookings"
