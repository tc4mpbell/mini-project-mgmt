class Project < ApplicationRecord
  belongs_to :organization
  has_many :categories
  has_many :tasks
end
