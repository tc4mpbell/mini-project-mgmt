class Organization < ApplicationRecord
  has_many :projects
  has_many :users
end
