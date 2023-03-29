class NodeDirectoryEntrySyncJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 0

  def perform(node_directory:, s3_key:)
    NodeDirectoryEntrySync.new(
      node_directory: node_directory,
      s3_key: s3_key
    ).sync!
  end
end
