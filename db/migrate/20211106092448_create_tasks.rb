class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :assigner_id
      t.integer :column_id

      t.timestamps
    end
  end
end
