class NodeDirectory < ApplicationRecord
  searchkick

  has_many :node_frameworks, dependent: :destroy
  validates :payload, :name, presence: true
end
