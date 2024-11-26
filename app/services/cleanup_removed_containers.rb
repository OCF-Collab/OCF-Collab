class CleanupRemovedContainers
  def self.cleanup(node_directory:, tracker_id:)
    tracker = NodeDirectorySyncTracker.new(tracker_id)
    return false if tracker.pending_entries.any?

    node_directory
      .containers
      .where.not(external_id: tracker.processed_container_ids.value)
      .delete_all

    true
  end
end
