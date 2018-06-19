class Organization < ApplicationRecord
  has_many :projects
  has_many :users

  def all_tasks
    @tasks = projects.flat_map {|project| project.all_tasks }
  end
end
