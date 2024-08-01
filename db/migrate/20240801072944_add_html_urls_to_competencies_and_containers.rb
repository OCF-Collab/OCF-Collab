class AddHtmlUrlsToCompetenciesAndContainers < ActiveRecord::Migration[7.1]
  def change
    add_column :competencies, :html_url, :string
    add_column :containers, :html_url, :string
  end
end
