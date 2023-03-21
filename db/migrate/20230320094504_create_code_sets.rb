class CreateCodeSets < ActiveRecord::Migration[7.0]
  def change
    create_table :code_sets, id: :uuid do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.timestamps

      t.index :external_id, unique: true
    end
  end
end
