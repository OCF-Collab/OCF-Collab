class Competency < ApplicationRecord
  searchkick

  belongs_to :container
  has_one :node_directory, through: :container
  has_many :competency_contextualizing_objects
  has_many :contextualizing_objects, through: :competency_contextualizing_objects

  validates :competency_text, presence: true

  def search_data
    as_json(
      include: {
        container: {
          only: %i[external_id name]
        }
      }
    )
  end
end
