class RenameCompetencyFrameworksToContainers < ActiveRecord::Migration[7.0]
  def change
    rename_table :competency_frameworks, :containers
    rename_column :competencies, :competency_framework_id, :container_id
  end
end
