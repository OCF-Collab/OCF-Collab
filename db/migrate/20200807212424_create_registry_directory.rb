class CreateRegistryDirectory < ActiveRecord::Migration[6.0]
  def change
    create_table :registry_directories do |t|
      t.string :uuid
      t.string :reference_id
      t.json :payload
      t.timestamps
    end
  end
end
