class NodeCompetency < ApplicationRecord
  searchkick

  belongs_to :node_framework
  validates :text, :payload, presence: true

end
