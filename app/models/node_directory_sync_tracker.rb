class NodeDirectorySyncTracker
  include Redis::Objects

  attr_reader :id
  set :pending_entries
  set :processed_container_ids

  def initialize(id = SecureRandom.uuid)
    @id = id
  end
end
