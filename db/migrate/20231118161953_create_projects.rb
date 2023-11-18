class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.boolean :active, default: true
      t.float :goal
      t.string :reward

      t.timestamps
    end
  end
end
