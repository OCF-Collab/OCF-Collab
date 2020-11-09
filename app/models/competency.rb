class Competency < ApplicationRecord
  belongs_to :competency_framework

  validates :competency_text, presence: true
end
