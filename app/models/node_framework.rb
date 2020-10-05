class NodeFramework < ApplicationRecord
  searchkick

  belongs_to :node_directory

  has_many :node_compentencies, dependent: :destroy
  validates :description, :name, :payload, :reference_id, :uuid, presence: true

  def contents
    require 'open-uri'
    contents = open(payload["@id"]).read
    JSON.parse(contents)
  end
end
