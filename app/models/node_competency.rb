class NodeCompetency < ApplicationRecord
  searchkick

  belongs_to :node_framework
  validates :text, :payload, :reference_id, presence: true

end
