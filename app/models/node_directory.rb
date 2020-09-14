class NodeDirectory < ApplicationRecord
  validates :name, presence: true
  validates :s3_bucket, presence: true
end
