class ContextualizingObjectCode < ApplicationRecord
  belongs_to :code
  belongs_to :contextualizing_object
end
