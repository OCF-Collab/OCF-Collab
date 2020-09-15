class CreateCompetencyFrameworks < ActiveRecord::Migration[6.0]
  def change
    create_table :competency_frameworks, id: :uuid do |t|
      t.references :node_directory, type: :uuid, null: false
      t.string :node_directory_s3_key, null: false
      t.string :external_id, null: false, index: true
      t.string :name, null: false, limit: 1000
      t.text :description

      t.timestamps
    end
  end
end
