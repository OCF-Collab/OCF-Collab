module Brokerage
  class BaseController < ActionController::API
    class InvalidParamsError < StandardError
      def initialize(msg = "Request contains missing or invalid parameters", params_errors: nil)
        @params_errors = params_errors
        super(msg)
      end
    end

    before_action :doorkeeper_authorize!
    around_action :tag_transaction_logger


    def sanitize_params!(sanitizer, params)
      s = sanitizer.new(params)

      if !s.valid?
        raise InvalidParamsError.new(params_errors: s.errors)
      end

      return s.cleaned
    end

    def tag_transaction_logger(&block)
      TransactionLogger.tagged({
        request_id: request.request_id,
        requester_application_id: doorkeeper_token.application.id,
        requester_application_name: doorkeeper_token.application.name,
        requester_directory_id: doorkeeper_token.application.node_directory&.id,
        requester_node_directory_name: doorkeeper_token.application.node_directory&.name,
      }, &block)
    end
  end
end
