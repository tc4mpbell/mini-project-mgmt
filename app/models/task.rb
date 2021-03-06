class Task < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :category, optional: true
  belongs_to :assignee, class_name: 'User', optional: true

  validates :project, presence: true
  validates :task, presence: true
  validates_uniqueness_of :task, scope: :category

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

  attr_reader :new_status

  def available_statuses
    valid_statuses = {
      ready_for_work:    %i(in_progress canceled),
      in_progress:       %i(blocked on_hold ready_for_review ready_for_work),
      blocked:           %i(ready_for_work),
      on_hold:           %i(ready_for_work),
      ready_for_review:  %i(failed_review ready_for_testing),
      failed_review:     %i(in_progress),
      ready_for_testing: %i(failed_testing ready_for_deploy),
      failed_testing:    %i(in_progress),
      ready_for_deploy:  %i(complete in_progress),
      complete:          %i(ready_for_work),
      canceled:          %i(ready_for_work)
    }

    valid_statuses[self.status.to_sym]
  end
end
