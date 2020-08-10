class AddNameToNodeDirectories < ActiveRecord::Migration[6.0]
  def change
    add_column :node_directories, :name, :string
  end
end
