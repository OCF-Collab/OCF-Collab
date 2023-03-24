class NodeDirectory < ApplicationRecord
  has_many :containers, dependent: :destroy
  has_many :contact_points, dependent: :destroy

  validates :name, presence: true
  validates :s3_bucket, presence: true
end
