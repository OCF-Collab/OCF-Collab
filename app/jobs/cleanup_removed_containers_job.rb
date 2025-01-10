class CleanupRemovedContainersJob < ApplicationJob
  DEFAULT_INTERVAL = 5 # in minutes

  sidekiq_options retry: 0

  def perform(node_directory:, tracker_id:)
    return if CleanupRemovedContainers.cleanup(node_directory:, tracker_id:)

    CleanupRemovedContainersJob
      .set(wait: internal.minutes)
      .perform_later(node_directory:, tracker_id:)
  end

  private

  def interval
    value = ENV.fetch('SYNC_CLEANUP_INTERVAL', 5).to_i
    value.zero? ? DEFAULT_INTERVAL : value
  end
end
