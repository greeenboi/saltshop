# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Clear existing data (optional, useful for development)
puts "Clearing existing data..."

# await user approval
puts "Do you want to continue? (y/n)"
input = STDIN.gets.chomp.downcase
exit unless input == 'y'

User.destroy_all
Role.destroy_all

# Create roles
puts "Creating roles..."
admin_role = Role.create!(name: 'admin')
user_role = Role.create!(name: 'user')
moderator_role = Role.create!(name: 'moderator')

puts "Created #{Role.count} roles"

# Create users
puts "Creating users..."

User.create!(
  username: 'admin',
  password: 'password123',
  password_confirmation: 'password123',
  role: admin_role,
  name: 'Admin User',
  email: 'admin@example.com',
  bio: 'System administrator'
)

User.create!(
  username: 'johndoe',
  password: 'password123',
  password_confirmation: 'password123',
  role: user_role,
  name: 'John Doe',
  email: 'john@example.com',
  bio: 'Regular user'
)

User.create!(
  username: 'janedoe',
  password: 'password123',
  password_confirmation: 'password123',
  role: moderator_role,
  name: 'Jane Doe',
  email: 'jane@example.com',
  bio: 'Content moderator'
)

puts "Created #{User.count} users"
puts "Seeding complete!"
