require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def test_status_availability
    valid_next_statuses_by_status = {
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

    valid_next_statuses_by_status.each do |status, next_statuses|
      assert_equal next_statuses.sort, build(:task, status: status).available_statuses.sort
    end
  end
end
