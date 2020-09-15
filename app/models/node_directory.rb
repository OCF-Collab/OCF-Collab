class NodeDirectory < ApplicationRecord
  has_many :competency_frameworks

  validates :name, presence: true
  validates :s3_bucket, presence: true
end
