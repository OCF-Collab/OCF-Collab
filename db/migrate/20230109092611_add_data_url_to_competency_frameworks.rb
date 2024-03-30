class AddDataUrlToCompetencyFrameworks < ActiveRecord::Migration[6.1]
  def change
    add_column :competency_frameworks, :data_url, :string
    add_index :competency_frameworks, :data_url

    reversible do |dir|
      dir.up do
        ApplicationRecord.connection.execute(<<~CMD)
          UPDATE competency_frameworks
          SET data_url = external_id
        CMD
      end
    end
  end
end
