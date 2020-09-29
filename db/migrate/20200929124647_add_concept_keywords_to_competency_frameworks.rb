class AddConceptKeywordsToCompetencyFrameworks < ActiveRecord::Migration[6.0]
  def change
    add_column :competency_frameworks, :concept_keywords, :string, array: true
  end
end
