class AddTeamworkIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :teamwork_id, :integer
    add_column :projects, :last_synced_tasks_with_teamwork, :datetime
  end
end
