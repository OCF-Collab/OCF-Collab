class Competency < ApplicationRecord
  belongs_to :competency_framework

  validates :name, presence: true
end
