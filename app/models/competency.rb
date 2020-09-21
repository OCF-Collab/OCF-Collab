class Competency < ApplicationRecord
  searchkick

  belongs_to :competency_framework

  validates :name, presence: true
end
