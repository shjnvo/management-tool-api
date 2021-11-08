class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :slug
      t.string :description
      t.string :status
      t.integer :creator_id

      t.timestamps
    end
  end
end
