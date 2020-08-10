namespace :local_sync do
  desc "Syncs and import registry and node directory data"
  task registry_and_node_directory: :environment do
    all_models_count_string

    if ENV['DELETE_ALL_DATA']
      puts "Clearing all data."
      all_models.map(&:delete_all)
    end

    puts all_models_count_string
    puts "Import started at #{DateTime.now}\n\n"

    process_registry_directory!

    process_node_directory!

    puts "Import completed at #{DateTime.now}"
    puts all_models_count_string
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
        registry_directory = RegistryDirectory.create_with({
          reference_id: entry["@id"],
          payload: entry
        }).find_or_create_by!({
          uuid: parse_uuid_from_url(entry["@id"])
        })

        puts "RegistryDirectory Upserted: #{registry_directory.inspect}\n\m"
      when 'RegistryEntry'
        registry_entry = RegistryEntry.create_with({
          reference_id: entry["@id"],
          name: entry["name"]["en-us"] || entry["name"]["en:us"],
          description: entry["description"]["en-us"],
          payload: entry
        }).find_or_create_by!({
          registry_directory: registry_directory,
          uuid: parse_uuid_from_url(entry["@id"])
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

    begin
      node_directory = NodeDirectory.create_with({
        reference_id: parsed_data["directory"]["@id"],
        name: parsed_data["directory"]["name"],
        payload: parsed_data["directory"]
      }).find_or_create_by!({
        uuid: parse_uuid_from_url(parsed_data["directory"]["@id"])
      })
    rescue Exception => e
      binding.pry
    end

    puts "NodeDirectory Upserted: #{node_directory.inspect}\n\m"


    node_framework = NodeFramework.create_with({
      reference_id: parsed_data["framework"]["@id"],
      name: parsed_data["framework"]["name"],
      description: parsed_data["framework"]["description"],
      payload: parsed_data["framework"],
    }).find_or_create_by!({
      node_directory: node_directory,
      uuid: parse_uuid_from_url(parsed_data["framework"]["@id"])
    })

    puts "NodeFramework Upserted: #{node_framework.inspect}\n\m"

    parsed_data["competencies"].each do |entry|

      node_competency = NodeCompetency.create_with({
        comment: entry["comment"]&.first,
        payload: entry
      }).find_or_create_by!({
        node_framework: node_framework,
        text: entry["text"] || entry["competencyText"]
      })

      puts "NodeFramework Upserted: #{node_framework.inspect}\n\m"
    end
  end

  ###########
  # Utility #
  ###########

  def all_models_count_string
    all_models.collect do |model|
      "#{model.to_s} : #{model.count}"
    end.join(" | ")
  end

  def all_models
    [RegistryDirectory, RegistryEntry, NodeFramework, NodeDirectory, NodeCompetency]
  end

  def parse_uuid_from_url(url)
    url.split('/')[-1] # can this be a regex?
  end
end
