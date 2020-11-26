class OauthApplication < ApplicationRecord
  include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application

  belongs_to :node_directory
end
