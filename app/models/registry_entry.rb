class RegistryEntry < ApplicationRecord
  searchkick

  validates :name, :description, :payload, :reference_id, :uuid, presence: true
  belongs_to :registry_directory

end
