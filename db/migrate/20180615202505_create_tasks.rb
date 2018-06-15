class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.text :task
      t.text :description
      t.references :project
      t.references :assignee, foreign_key: { to_table: :users }

      t.integer :status

      t.timestamps
    end
  end
end
