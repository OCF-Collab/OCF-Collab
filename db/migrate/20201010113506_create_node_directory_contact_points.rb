class CreateNodeDirectoryContactPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_points, id: :uuid do |t|
      t.references :node_directory, type: :uuid, null: :false
      t.string :email, null: false
      t.string :name
      t.string :title

      t.timestamps
    end
  end
end
