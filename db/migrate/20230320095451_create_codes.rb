class CreateCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :codes, id: :uuid do |t|
      t.string :description
      t.references :code_set, foreign_key: { on_delete: :cascade }, null: false, type: :uuid
      t.string :name, null: false
      t.string :value, null: false
      t.timestamps

      t.index [:code_set_id, :value], unique: true
    end
  end
end
