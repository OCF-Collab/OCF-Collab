class ContextualizingObject < ApplicationRecord
  self.inheritance_column = nil

  has_many :competency_contextualizing_objects
  has_many :competencies, through: :competency_contextualizing_objects
  has_many :contextualizing_object_codes
  has_many :codes, through: :contextualizing_object_codes
end
