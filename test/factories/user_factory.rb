FactoryBot.define do
  factory :user do
    first_name "John"
    last_name  "Doe"

    password '1'

    sequence :email do |n|
      "person#{n}@example.com"
    end

    email
    
    organization
  end
end