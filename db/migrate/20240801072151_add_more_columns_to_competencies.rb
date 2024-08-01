class AddMoreColumnsToCompetencies < ActiveRecord::Migration[7.1]
  def change
    add_column :competencies, :competency_category, :string
    add_column :competencies, :competency_label, :string
    add_column :competencies, :keywords, :string, array: true, default: []
  end
end
