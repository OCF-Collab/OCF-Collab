class AddDataUrlToCompetencyFrameworks < ActiveRecord::Migration[6.1]
  def change
    add_column :competency_frameworks, :data_url, :string
    add_index :competency_frameworks, :data_url

    reversible do |dir|
      dir.up do
        CompetencyFramework.update_all("data_url = external_id")
      end
    end
  end
end
