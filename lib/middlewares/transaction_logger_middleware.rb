class TransactionLoggerMiddleware
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    TransactionLogger.tagged(request_id: env["action_dispatch.request_id"]) do
      app.call(env)
    end
  end
end
