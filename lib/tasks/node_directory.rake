namespace :node_directory do
  desc "Syncs entries from a node directory's S3 bucket"
  task "sync", [:node_directory_id] => [:environment] do |t, args|
    if (external_id = args[:node_directory_id]).present?
      NodeDirectorySync
        .new(node_directory: NodeDirectory.find_by!(external_id:))
        .sync!
    else
      NodeDirectorySync.sync_all!
    end
  end
end
