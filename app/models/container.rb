class Container < ApplicationRecord
  self.inheritance_column = nil

  searchkick

  belongs_to :node_directory
  has_many :competencies, dependent: :destroy

  validates :node_directory_s3_key, presence: true
  validates :external_id, presence: true
  validates :name, presence: true

  def search_data
    as_json(
      include: {
        competencies: {
          only: [
            :competency_text,
            :comment,
          ]
        }
      }
    )
  end
end
