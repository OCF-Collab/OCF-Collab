class RegistryDirectory < ApplicationRecord
  searchkick

  validates :payload, :reference_id, :uuid, presence: true

end
