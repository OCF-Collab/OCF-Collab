class AddExternalIdToCompetencies < ActiveRecord::Migration[6.1]
  def change
    add_column :competencies, :external_id, :string
    add_index :competencies, :external_id, unique: true
  end
end
