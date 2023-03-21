class CreateContextualizingObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :contextualizing_objects, id: :uuid do |t|
      t.string :coded_notation
      t.string :data_url, null: false
      t.string :description
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.timestamps

      t.index :external_id, unique: true
      t.index :type
    end
  end
end
