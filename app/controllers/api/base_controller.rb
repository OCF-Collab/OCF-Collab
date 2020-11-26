module Api
  class BaseController < ActionController::API
    before_action :doorkeeper_authorize!
    around_action :tag_transaction_logger

    def tag_transaction_logger(&block)
      TransactionLogger.tagged({
        request_id: request.request_id,
        oauth_application_id: doorkeeper_token.application.id,
        oauth_application_name: doorkeeper_token.application.name,
        oauth_application_node_directory_id: doorkeeper_token.application.node_directory&.id,
        oauth_application_node_directory_name: doorkeeper_token.application.node_directory&.name,
      }, &block)
    end
  end
end
