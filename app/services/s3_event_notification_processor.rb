class S3EventNotificationProcessor
  VALID_EVENT_NAMES = [
    "ObjectCreated:Put",
    "ObjectCreated:Post",
    "ObjectCreated:Copy",
    "ObjectCreated:CompleteMultipartUpload",
    "ObjectRemoved:Delete",
    "ObjectRemoved:DeleteMarkerCreated",
  ]

  attr_reader :event_notification

  def initialize(event_notification:)
    @event_notification = event_notification
  end

  def process!
    if !VALID_EVENT_NAMES.include?(event_name)
      raise ArgumentError, "Invalid S3 event notification event name"
    end

    enqueue_sync!
  end

  def event_name
    event_notification["eventName"]
  end

  def enqueue_sync!
    NodeDirectoryEntrySyncJob.perform_later(
      node_directory: node_directory,
      s3_key: s3_key,
    )
  end

  def node_directory
    @node_directory ||= NodeDirectory.find_by_s3_bucket!(s3_bucket)
  end

  def s3_bucket
    bucket_data["name"]
  end

  def bucket_data
    s3_data["bucket"]
  end

  def s3_data
    event_notification["s3"]
  end

  def s3_key
    object_data["key"]
  end

  def object_data
    s3_data["object"]
  end
end
