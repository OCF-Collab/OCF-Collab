class AddTypeToContainers < ActiveRecord::Migration[7.0]
  def change
    add_column :containers, :type, :string, default: "CompetencyFramework", null: false
    add_index :containers, :type
  end
end
