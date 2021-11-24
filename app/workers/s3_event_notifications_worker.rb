class S3EventNotificationsWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'ocf-collab-s3-event-notifications', auto_delete: true

  def perform(sqs_message, body)
    data = JSON.parse(body)
    data["Records"].each do |record|
      S3EventNotificationProcessor.new(event_notification: record).process!
    end
  end
end
