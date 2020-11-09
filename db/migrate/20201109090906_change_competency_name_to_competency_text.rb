class ChangeCompetencyNameToCompetencyText < ActiveRecord::Migration[6.0]
  def change
    rename_column :competencies, :name, :competency_text
    change_column :competencies, :competency_text, :text, null: false
  end
end
