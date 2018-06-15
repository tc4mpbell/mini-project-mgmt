class Task < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :category, optional: true
  belongs_to :assignee, class_name: 'User', optional: true

  validate :must_belong_to_either_project_or_category

  enum status: [ 
    on_hold: 1, 
    blocked: 2, 
    in_progress: 3,
    ready_for_review: 4,
    failed_review: 5,
    ready_for_testing: 6,
    failed_testing: 7,
    ready_for_deploy: 8,
    complete: 9
  ]

  private

  def must_belong_to_either_project_or_category
    errors.add(:base, "must belong to either a project or a category") unless category.present? || project.present?
  end
end
