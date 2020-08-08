namespace :local_sync do
  desc "Syncs and import registry and node directory data"
  task registry_and_node_directory: :environment do
    puts "Clearing all data."

    # [RegistryDirectory, RegistryEntry, NodeFramework, NodeDirectory, NodeCompetency].map(&:destroy_all)

    puts "Import started at #{DateTime.now}\n\n"

    process_registry_directory!

    process_node_directory!

    puts "Import completed at #{DateTime.now}"

  end

  private


  ##############################
  # Registry Directory IMPORT #
  ############################

  def process_registry_directory!
    registry_data_pathnames = Dir["#{Rails.root}/private/registry_directory/*.json"]

    registry_data_pathnames.each do |pathname|
      import_registry_directory_json_file!(pathname)
    end
  end

  def import_registry_directory_json_file!(pathname)
    json_data = File.read(pathname)
    parsed_data = JSON.parse(json_data)
    registry_directory = nil

    parsed_data["@graph"].each do |entry|
      case entry["@type"]
      when "RegistryDirectory"
        registry_directory = RegistryDirectory.create({
          uuid: parse_uuid_from_url(entry["@id"]),
          reference_id: entry["@id"],
          payload: entry
        })

        puts "RegistryDirectory Upserted: #{registry_directory.inspect}\n\m"
      when 'RegistryEntry'
        registry_entry = RegistryEntry.create({
          uuid: parse_uuid_from_url(entry["@id"]),
          reference_id: entry["@id"],
          registry_directory: registry_directory,
          name: entry["name"]["en-us"],
          description: entry["description"]["en-us"],
          payload: entry
        })

        puts "RegistryEntry Upserted: #{registry_entry.inspect}\n\m"
      else
        puts "\nWARNING: Invalid data type for:"
        puts entry.inspect
      end
    end
  end

  ##############################
  # Registry Directory IMPORT #
  ############################

  def process_node_directory!
    node_data_pathnames = Dir["#{Rails.root}/private/node_directory/*.json"]

    node_data_pathnames.each do |pathname|
      import_node_directory_json_file!(pathname)
    end
  end

  def import_node_directory_json_file!(pathname)
    json_data = File.read(pathname)
    parsed_data = JSON.parse(json_data)

    node_directory = NodeDirectory.create({
      uuid: parse_uuid_from_url(parsed_data["directory"]["@id"]),
      reference_id: parsed_data["directory"]["@id"],
      payload: parsed_data["directory"]
    })

    puts "NodeDirectory Upserted: #{node_directory.inspect}\n\m"


    node_framework = NodeFramework.create({
      node_directory: node_directory,
      uuid: parse_uuid_from_url(parsed_data["framework"]["@id"]),
      reference_id: parsed_data["framework"]["@id"],
      name: parsed_data["framework"]["name"],
      description: parsed_data["framework"]["description"],
      payload: parsed_data["framework"],
    })

    puts "NodeFramework Upserted: #{node_framework.inspect}\n\m"

    parsed_data["competencies"].each do |entry|
      node_competency = NodeCompetency.create({
        text: entry["text"],
        comment: entry["comment"]&.first,
        node_framework: node_framework,
        payload: entry
      })

      puts "NodeFramework Upserted: #{node_framework.inspect}\n\m"
    end
  end

  ###########
  # Utility #
  ###########

  def parse_uuid_from_url(url)
    url.split('/')[-1] # can this be a regex?
  end
end
