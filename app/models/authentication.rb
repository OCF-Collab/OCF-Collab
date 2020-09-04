class Authentication < ApplicationRecord
  searchkick

  validates :auth, presence: true

  def self.app_authenticated?
    where(enabled: true).count > 0
  end
end
