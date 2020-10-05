class CreateRegisteryEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :registry_entries do |t|
      t.string :name
      t.string :uuid
      t.string :reference_id
      t.text :description
      t.json :payload

      t.timestamps
    end
  end
end
