# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'open-uri'
require 'fileutils'

# Clear existing data
puts "Clearing existing data..."
Photo.destroy_all
Album.destroy_all
User.destroy_all

puts "Creating seed data..."

# Helper method to download and save images
def download_and_save_image(url, filename)
  begin
    puts "Downloading #{filename}..."

    # Create uploads directory if it doesn't exist
    uploads_dir = Rails.root.join('public', 'uploads', 'tmp')
    FileUtils.mkdir_p(uploads_dir)

    # Download the image
    downloaded_image = URI.open(url)

    # Save to temporary file
    temp_file = File.join(uploads_dir, filename)
    File.open(temp_file, 'wb') do |file|
      file.write(downloaded_image.read)
    end

    # Return the file for CarrierWave
    File.open(temp_file)
  rescue => e
    puts "Error downloading #{filename}: #{e.message}"
    nil
  end
end

#  Users
users = []
avatar_urls = [
  "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1494790108755-2616b80b6ad6?w=150&h=150&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face"
]

user_data = [
  { first_name: "John", last_name: "Doe", email: "john.doe@example.com", role: true },
  { first_name: "Jane", last_name: "Smith", email: "jane.smith@example.com", role: false },
  { first_name: "Mike", last_name: "Johnson", email: "mike.johnson@example.com", role: false },
  { first_name: "Sarah", last_name: "Wilson", email: "sarah.wilson@example.com", role: false },
  { first_name: "David", last_name: "Brown", email: "david.brown@example.com", role: false }
]

user_data.each_with_index do |data, index|
  # For simplicity, we'll just store avatar URLs directly for users
  # You can also implement avatar upload similar to photos if needed
  users << User.create!(
    first_name: data[:first_name],
    last_name: data[:last_name],
    email: data[:email],
    password: "password123",
    password_confirmation: "password123",
    active: true,
    role: data[:role],
    avatar: avatar_urls[index]
  )
end

puts "Created #{users.count} users"

#  Photos
photos = []
photo_titles = [
  "Beautiful Sunset", "Mountain View", "City Lights", "Ocean Waves", "Forest Path",
  "Desert Landscape", "Winter Wonderland", "Spring Flowers", "Summer Beach", "Autumn Colors",
  "Street Photography", "Portrait Session", "Nature Close-up", "Architecture", "Food Photography"
]

photo_descriptions = [
  "A breathtaking sunset over the horizon",
  "Majestic mountain peaks covered in snow",
  "Vibrant city lights illuminating the night",
  "Powerful ocean waves crashing on the shore",
  "A serene path through the dense forest",
  "Vast desert with golden sand dunes",
  "Snow-covered trees in winter",
  "Colorful spring flowers in bloom",
  "Perfect sunny day at the beach",
  "Beautiful autumn foliage colors",
  "Candid moments captured on the street",
  "Professional portrait photography",
  "Macro photography of nature",
  "Modern architectural masterpiece",
  "Delicious gourmet food presentation"
]

# Sample photo URLs
photo_urls = [
  "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1514924013411-cbf25faa35bb?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1478827217976-025cbdaa33bf?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1504700610630-ac6aba3536d3?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1492571350019-22de08371fd3?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1480714378408-67cf0d13bc1f?w=800&h=600&fit=crop",
  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=600&fit=crop"
]

15.times do |i|
  user = users.sample

  # Download image file
  image_file = download_and_save_image(photo_urls[i], "photo_#{i + 1}.jpg")

  if image_file
    photo = Photo.create!(
      title: photo_titles[i],
      description: photo_descriptions[i],
      user: user,
      publication_date: rand(30.days).seconds.ago,
      sharing_mode: [ true, false ].sample,
      is_standalone: [ true, false ].sample,
      likes_count: rand(0..100),
      image: image_file
    )
    photos << photo
    image_file.close
  else
    puts "Skipping photo #{i + 1} due to download error"
  end
end

puts "Created #{photos.count} photos"

# Create Albums
albums = []
album_titles = [
  "Travel Memories", "Family Moments", "Nature Collection", "City Adventures", "Holiday Photos",
  "Portrait Gallery", "Food Journey", "Architecture Tour", "Sunset Collection", "Wildlife Photos"
]

album_descriptions = [
  "Collection of photos from my travels around the world",
  "Precious moments with family and friends",
  "Beautiful nature photography collection",
  "Urban exploration and city life",
  "Memorable holiday celebrations",
  "Portrait photography showcase",
  "Culinary adventures and food photography",
  "Architectural wonders from different cities",
  "Stunning sunset photographs",
  "Wildlife and animal photography"
]

10.times do |i|
  user = users.sample
  album = Album.create!(
    title: album_titles[i],
    description: album_descriptions[i],
    user: user,
    publication_date: rand(60.days).seconds.ago,
    sharing_mode: [ true, false ].sample,
    likes_count: rand(0..50)
  )
  albums << album
end

puts "Created #{albums.count} albums"

# Add photos to albums (many-to-many relationship)
albums.each do |album|
  # Add 2-5 random photos to each album
  random_photos = photos.sample(rand(2..5))
  album.photos = random_photos
end

puts "Added photos to albums"

# Create follows (user following relationships)
users.each do |user|
  # Each user follows 1-3 other users
  other_users = users - [ user ]
  followers = other_users.sample(rand(1..3))
  user.followings = followers
end

puts "Created follow relationships"

# Create likes for photos
photos.each do |photo|
  # Each photo gets liked by 0-3 random users
  likers = users.sample(rand(0..3))
  photo.liked_users = likers
end

puts "Created photo likes"

# Create likes for albums
albums.each do |album|
  # Each album gets liked by 0-3 random users
  likers = users.sample(rand(0..3))
  album.liked_users = likers
end

puts "Created album likes"

puts "\n=== Seed Data Summary ==="
puts "Users: #{User.count}"
puts "Photos: #{Photo.count}"
puts "Albums: #{Album.count}"
puts "Total follows: #{User.joins(:followings).count}"
puts "Total photo likes: #{Photo.joins(:liked_users).count}"
puts "Total album likes: #{Album.joins(:liked_users).count}"
puts "\nSeed data created successfully!"
