TransactionLogger = ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join("log", "logstash.txt")))

TransactionLogger.formatter.instance_eval do
  def call(severity, time, progname, msg)
    LogStash::Event.new(logstash_payload(msg)).to_json + "\n"
  end

  def logstash_payload(msg)
    tags_payload = current_tags.reduce(Hash.new, :merge)

    if msg.is_a?(Hash)
      return tags_payload.merge(msg)
    end

    return tags_payload.merge({
      message: msg,
    })
  end
end
