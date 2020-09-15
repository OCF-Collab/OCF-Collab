class NodeDirectoryEntrySyncJob < ApplicationJob
  queue_as :default

  def perform(node_directory:, s3_key:)
    NodeDirectoryEntrySync.new(
      node_directory: node_directory,
      s3_key: s3_key
    ).sync!
  end
end
