# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  require "#{Rails.root}/db/seeds/development.rb"
end


example_org = Organization.find_or_create_by(name: "My First Org")

admin = User.find_or_initialize_by(
  first_name: 'Jane', 
  last_name: 'Smith', 
  organization: example_org, 
  email: 'jane@example.com').tap do |u|
  u.password = "password"
  u.save!
end


example_org.projects.find_or_create_by(name: 'First Project')