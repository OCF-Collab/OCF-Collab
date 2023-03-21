class CompetencyContextualizingObject < ApplicationRecord
  belongs_to :competency
  belongs_to :contextualizing_object
end
