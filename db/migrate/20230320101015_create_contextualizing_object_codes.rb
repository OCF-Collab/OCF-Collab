class CreateContextualizingObjectCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :contextualizing_object_codes, id: :uuid do |t|
      t.references :code, foreign_key: { on_delete: :cascade }, index: false, null: false, type: :uuid
      t.references :contextualizing_object, foreign_key: { on_delete: :cascade }, index: false, null: false, type: :uuid
      t.timestamps

      t.index %i[code_id contextualizing_object_id], name: 'index_contextualizing_object_codes', unique: true
    end
  end
end
