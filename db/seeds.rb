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
require "http"
require "json"

def fetch_bios(specialty, mentors_per_specialty)
  api_key = ENV["OPEN_AI_API_KEY"]
  url = "https://api.openai.com/v1/chat/completions"

  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{api_key}"
  }

  prompt = "We're building a website for finding a mentor. Please compose #{mentors_per_specialty} different 1 paragraph bios for mentors in the #{specialty} field. Please do not include the mentor's name. Please use a random number of years of experience between 10 and 20. Please number each bio. Please separate each bio with two carriage returns."

  # puts "OpenAI prompt: #{prompt}"

  # Set up the request body
  body = {
    model: 'gpt-3.5-turbo',
    messages: [
      { "role": "user", "content": prompt }
    ],
    max_tokens: 1000
  }.to_json

  response = HTTP.headers(headers).post(url, body: body)
  response_data = JSON.parse(response.body.to_s)
  final = response_data["choices"].first["message"]["content"]
  # puts "output: #{final}"
  bios = final.split("\n\n").map do |bio|
    final_bio = bio.gsub(/^([^ ]+ )/, "")
    # p final_bio
    final_bio
  end
  return bios
end

puts "starting up"
puts "clearing the db"
Booking.destroy_all
Mentor.destroy_all
User.destroy_all

mentors_per_specialty = 8

puts "generating bios with OpenAI"
BIOS = {}
Mentor::SPECIALTIES.each do |specialty|
  BIOS[specialty] = fetch_bios(specialty, mentors_per_specialty)
  puts "generated bios for #{specialty}"
end

def create_user_and_mentor(specialty, input_email = nil, input_name = nil, input_photo_url = nil, input_bio = nil)
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
  remaining_bios = BIOS[specialty]
  if remaining_bios.blank?
    bio = input_bio.nil? ? Faker::Lorem.paragraphs(number: 5).join("\n\n") : input_bio
  else
    bio = remaining_bios.last
    BIOS[specialty] = remaining_bios.reverse.drop(1).reverse
  end
  tagline = bio.split(".").first + "."
  mentor = Mentor.create!(user: user, specialty: specialty, price: price, tagline: tagline, bio: bio)
  mentor.photo.attach(io: file, filename: "user.png", content_type: 'image/png')
  return {name: name, email: email, tagline: tagline}
end

def create_user(email, name)
  user = User.create!(email: email, password: "password", name: name)
end

num_created = 0
total = Mentor::SPECIALTIES.count * mentors_per_specialty
puts "creating #{total} fake mentors"
Mentor::SPECIALTIES.each do |specialty|
  mentors_per_specialty.times do
    result = create_user_and_mentor(specialty, nil, nil, "app/assets/images/#{num_created}.jpg", nil)
    num_created += 1
    puts "#{num_created} / #{total}: finished creating a user and mentor for: #{result[:name]}, #{result[:email]}. tagline: #{result[:tagline]}"
  end
end

puts "creating 3 users for our team"
team_users = [
  { email: "riyaf3105@gmail.com", name: "Riya Fartyal", photo_url: "https://avatars.githubusercontent.com/u/83643548?v=4" },
  { email: "justin.garcia@gmail.com", name: "Justin Garcia", photo_url: "https://avatars.githubusercontent.com/u/8378384", bio: "I'm an iOS developer from Florida. I'd love to help with Core Data, Swift or SwiftUI."},
  { email: "fangshuxing0613@gmail.com", name: "Shuxing Fang", photo_url: "https://avatars.githubusercontent.com/u/151457729?v=4" }
]
standard_user = { email: "standard-user@gmail.com", name: "John Smith" }
team_users.each do |hash|
  create_user_and_mentor(Mentor::SPECIALTIES.sample, hash[:email], hash[:name], hash[:photo_url], hash[:bio])
end

create_user(standard_user[:email], standard_user[:name])

puts "creating bookings"
team_users.each do |team_user_hash|
  team_user = User.where(email: team_user_hash[:email]).first
  # make 7 bookings where team_user is the mentee:
  7.times do
    mentor = Mentor.all.sample
    next if team_user == mentor.user

    Booking.create!(user: team_user, mentor: mentor, start_time: rand(4.weeks).seconds.ago, status: Booking::STATUSES.sample)
  end
  # make bookings where team_user is the mentor:
  Booking::STATUSES.each do |status|
    3.times do
      user = User.all.sample
      next if team_user == user

      Booking.create!(user: user, mentor: Mentor.where(user: team_user).first, start_time: rand(4.weeks).seconds.ago, status: status)
    end
  end
end

puts "done. generated #{User.count} users and #{Mentor.count} mentors and #{Booking.count} bookings"
