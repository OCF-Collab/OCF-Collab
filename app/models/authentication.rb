class Authentication < ApplicationRecord
  searchkick

  validates :auth, presence: true

  def self.app_authenticated?
    where(enabled: true).count
  end
end
