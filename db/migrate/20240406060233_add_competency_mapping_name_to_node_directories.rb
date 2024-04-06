class AddCompetencyMappingNameToNodeDirectories < ActiveRecord::Migration[7.1]
  def change
    add_column :node_directories, :competency_mapping_name, :string
  end
end
