class Project < ApplicationRecord
  belongs_to :organization
  has_many :categories
  has_many :tasks

  def all_tasks
    tasks + categories.flat_map {|cat| cat.tasks }
  end
end
