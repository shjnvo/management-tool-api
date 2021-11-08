class CreateColumns < ActiveRecord::Migration[6.1]
  def change
    create_table :columns do |t|
      t.string :title
      t.string :description
      t.integer :sort_order
      t.integer :project_id

      t.timestamps
    end
  end
end
