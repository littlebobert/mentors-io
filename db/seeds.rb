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

Mentor.destroy_all
User.destroy_all

10.times do
  user = User.create!(email: Faker::Internet.unique.email, password: "password", name: Faker::Name.unique.name)
  price = (50..1000).to_a.sample

  url = "https://this-person-does-not-exist.com/new?gender=all&age=25-50&etnic=all"
  json = URI.open(url).string
  src = JSON.parse(json)['src']
  photo_url = "https://this-person-does-not-exist.com#{src}"
  file = URI.open(photo_url)
  mentor = Mentor.create!(user: user, specialty: Mentor::SPECIALTIES.sample, price: price)
  mentor.photo.attach(io: file, filename: "user.png", content_type: 'image/png')
  puts "finished 1 mentor"
end

puts "generated #{User.count} users and #{Mentor.count} mentors"
