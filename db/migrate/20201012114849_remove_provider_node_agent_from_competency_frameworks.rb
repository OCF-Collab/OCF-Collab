class RemoveProviderNodeAgentFromCompetencyFrameworks < ActiveRecord::Migration[6.0]
  def change
    remove_column :competency_frameworks, :provider_node_agent
  end
end
