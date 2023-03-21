class CreateCompetencyContextualizingObjects < ActiveRecord::Migration[7.0]
  def change
    create_table :competency_contextualizing_objects, id: :uuid do |t|
      t.references :competency, foreign_key: { on_delete: :cascade }, index: false, null: false, type: :uuid
      t.references :contextualizing_object, foreign_key: { on_delete: :cascade }, index: false, null: false, type: :uuid
      t.timestamps

      t.index [:competency_id, :contextualizing_object_id], name: "index_competency_contextualizing_objects", unique: true
    end
  end
end
