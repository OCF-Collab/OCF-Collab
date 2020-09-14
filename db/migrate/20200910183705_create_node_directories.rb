class CreateNodeDirectories < ActiveRecord::Migration[6.0]
  def change
    create_table :node_directories, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :s3_bucket, null: false

      t.timestamps
    end
  end
end
