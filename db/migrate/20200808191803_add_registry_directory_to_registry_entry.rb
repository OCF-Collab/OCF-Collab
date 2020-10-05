class AddRegistryDirectoryToRegistryEntry < ActiveRecord::Migration[6.0]
  def change
    add_column :registry_entries, :registry_directory_id, :integer
    add_index :registry_entries, :registry_directory_id
  end
end
