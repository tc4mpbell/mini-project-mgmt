class AddTeamworkTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :teamwork_access_token, :string
  end
end
