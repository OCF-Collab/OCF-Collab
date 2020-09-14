class NodeDirectoryEntrySyncJob < ApplicationJob
  def perform(node_directory_id:, s3_key:)
    node_directory = NodeDirectory.find(node_directory_id)

    NodeDirectoryEntrySync.new(
      node_directory: node_directory,
      s3_key: s3_key
    ).sync!
  end
end
