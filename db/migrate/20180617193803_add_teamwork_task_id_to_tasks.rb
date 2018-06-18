class AddTeamworkTaskIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :teamwork_id, :integer
  end
end
