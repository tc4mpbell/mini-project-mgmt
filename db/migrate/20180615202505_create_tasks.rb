class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.text :task
      t.text :description
      t.references :project
      t.references :assignee, foreign_key: { to_table: :users }

      # default to ready for work
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
