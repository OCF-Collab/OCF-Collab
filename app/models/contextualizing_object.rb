class ContextualizingObject < ApplicationRecord
  self.inheritance_column = nil

  enum :type, {
    credential: "Credential",
    industry: "Industry",
    learn_opp: "LearningOpportunity",
    occupation: "Occupation"
  }

  has_many :competency_contextualizing_objects
  has_many :competencies, through: :competency_contextualizing_objects
  has_many :contextualizing_object_codes
  has_many :codes, through: :contextualizing_object_codes

  def text
    [coded_notation, description, name, *codes.pluck(:value)].compact.join(" ")
  end
end
