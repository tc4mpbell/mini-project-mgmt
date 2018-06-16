class Task < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :category, optional: true
  belongs_to :assignee, class_name: 'User', optional: true

  validate :must_belong_to_either_project_or_category
  validates :task, presence: true

  enum status: {
    ready_for_work: 0,
    on_hold: 1, 
    blocked: 2, 
    in_progress: 3,
    ready_for_review: 4,
    failed_review: 5,
    ready_for_testing: 6,
    failed_testing: 7,
    ready_for_deploy: 8,
    complete: 9,
    canceled: 10
  }

  def available_statuses
    valid_statuses = {
      ready_for_work:    %i(in_progress canceled),
      in_progress:       %i(blocked on_hold ready_for_review canceled ready_for_work),
      blocked:           %i(ready_for_work canceled),
      on_hold:           %i(ready_for_work canceled),
      ready_for_review:  %i(failed_review ready_for_testing canceled),
      failed_review:     %i(in_progress canceled),
      ready_for_testing: %i(failed_testing ready_for_deploy canceled),
      failed_testing:    %i(in_progress canceled),
      ready_for_deploy:  %i(complete in_progress canceled),
      complete:          %i(ready_for_work),
      canceled:          %i(ready_for_work)
    }

    valid_statuses[self.status.to_sym]
  end

  private

  def must_belong_to_either_project_or_category
    errors.add(:base, "must belong to either a project or a category") unless category.present? || project.present?
  end
end
