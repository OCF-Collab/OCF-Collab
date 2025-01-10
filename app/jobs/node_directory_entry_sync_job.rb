class NodeDirectoryEntrySyncJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 0

  def perform(node_directory:, s3_key:, tracker_id:)
    tracker = NodeDirectorySyncTracker.new(tracker_id)

    NodeDirectoryEntrySync.new(
      node_directory: node_directory,
      s3_key: s3_key,
      tracker:
    ).sync!
  end
end
