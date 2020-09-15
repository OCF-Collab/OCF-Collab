class CompetencyFramework < ApplicationRecord
  belongs_to :node_directory
  has_many :competencies

  validates :node_directory_s3_key, presence: true
  validates :external_id, presence: true
  validates :name, presence: true
end
