class AddTasklistIdToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :teamwork_list_id, :integer
  end
end
