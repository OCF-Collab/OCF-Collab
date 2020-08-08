class NodeFramework < ApplicationRecord
  searchkick

  belongs_to :node_directory

  has_many :node_compentencies, dependent: :destroy
  validates :description, :name, :payload, :reference_id, :uuid, presence: true
end
