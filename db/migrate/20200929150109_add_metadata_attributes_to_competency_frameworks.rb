class AddMetadataAttributesToCompetencyFrameworks < ActiveRecord::Migration[6.0]
  def change
    add_column :competency_frameworks, :attribution_name, :string, null: false
    add_column :competency_frameworks, :attribution_url, :string, null: false
    add_column :competency_frameworks, :provider_node_agent, :string, null: false
    add_column :competency_frameworks, :provider_meta_model, :string, null: false
    add_column :competency_frameworks, :beneficiary_rights, :string, null: false
    add_column :competency_frameworks, :registry_rights, :string, null: false
  end
end
