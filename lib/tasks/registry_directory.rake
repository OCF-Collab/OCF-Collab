namespace :registry_directory do
  desc "Updates Registry Directory configuration from file"
  task "sync_from_file", [:filepath] => [:environment] do |t, args|
    filepath = args[:filepath] || Rails.root.join("config", "registry_directory.json")

    RegistryDirectory::SyncFromFile.new(filepath: filepath).sync!
  end
end
