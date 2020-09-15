class CreateCompetencies < ActiveRecord::Migration[6.0]
  def change
    create_table :competencies, id: :uuid do |t|
      t.references :competency_framework, type: :uuid, null: false
      t.string :name, null: false, limit: 1000
      t.text :comment

      t.timestamps
    end
  end
end
