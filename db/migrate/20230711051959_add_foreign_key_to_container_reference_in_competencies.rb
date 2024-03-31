class AddForeignKeyToContainerReferenceInCompetencies < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :competencies, :containers, on_delete: :cascade
  end
end
