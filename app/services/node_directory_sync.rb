class NodeDirectorySync
  attr_reader :node_directory, :delete_existing

  def initialize(node_directory:, delete_existing: true)
    @node_directory = node_directory
    @delete_existing = delete_existing
  end

  def self.sync_all!
    NodeDirectory.find_each do |node_directory|
      self.new(node_directory: node_directory).sync!
    end
  end

  def sync!
    delete_existing_containers! if delete_existing
    sync_page!
    return if delete_existing

    CleanupRemovedContainersJob.perform_later(
      node_directory:,
      tracker_id: tracker.id
    )
  end

  private

  def delete_existing_containers!
    node_directory.containers.delete_all
  end

  def sync_page!(continuation_token: nil)
    page_sync = NodeDirectoryPageSync.new(
      continuation_token:,
      node_directory:,
      tracker:
    )

    page_sync.sync!

    if page_sync.has_next_page?
      sync_page!(continuation_token: page_sync.next_page_continuation_token)
    end
  end

  def tracker
    @tracker ||= NodeDirectorySyncTracker.new
  end

  class NodeDirectoryPageSync
    attr_reader :continuation_token, :node_directory, :tracker

    def initialize(continuation_token:, node_directory:, tracker:)
      @node_directory = node_directory
      @continuation_token = continuation_token
      @tracker = tracker
    end

    def sync!
      s3_objects.each do |s3_object|
        s3_key = s3_object[:key]
        tracker.pending_entries << s3_key

        NodeDirectoryEntrySyncJob.perform_later(
          node_directory:,
          s3_key:,
          tracker_id: tracker.id
        )
      end
    end

    def s3_objects
      @s3_objects ||= s3_list_response.contents
    end

    def s3_list_response
      @s3_list_response ||= s3_client.list_objects_v2(
        bucket: node_directory.s3_bucket,
        continuation_token: continuation_token,
      )
    end

    def s3_client
      @s3_client ||= S3Client.new(node_directory:)
    end

    def has_next_page?
      s3_list_response.is_truncated
    end

    def next_page_continuation_token
      s3_list_response.next_continuation_token
    end
  end
end
