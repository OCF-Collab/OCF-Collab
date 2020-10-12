class AddExtendedAttributesToNodeDirectories < ActiveRecord::Migration[6.0]
  def change
    add_column :node_directories, :external_id, :string, null: false
    add_column :node_directories, :logo_url, :string
  end
end
