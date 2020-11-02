class AddPnaUrlToNodeDirectories < ActiveRecord::Migration[6.0]
  def change
    add_column :node_directories, :pna_url, :string
  end
end
