class AddNodeDirectoryModels < ActiveRecord::Migration[6.0]
  def change
    create_table :node_directories do |t|
      t.string :uuid
      t.string :reference_id
      t.json :payload
      t.timestamps
    end

    create_table :node_frameworks do |t|
      t.references :node_directory
      t.string :uuid
      t.string :reference_id
      t.string :name
      t.text :description
      t.json :payload
      t.timestamps
    end

    create_table :node_competencies do |t|
      t.references :node_framework
      t.string :reference_id
      t.string :text
      t.string :comment
      t.json :payload
      t.timestamps
    end
  end
end
