class Competency < ApplicationRecord
  searchkick

  belongs_to :competency_framework
  has_one :node_directory, through: :competency_framework

  validates :competency_text, presence: true

  def search_data
    as_json(
      include: {
        competency_framework: {
          only: %i[external_id name]
        }
      }
    )
  end
end
