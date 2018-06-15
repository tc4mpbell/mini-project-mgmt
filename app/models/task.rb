class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: 'User', optional: true

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
end
