module RegistryDirectory
  class SyncFromFile
    attr_reader :filepath

    def initialize(filepath:)
      @filepath = filepath
    end

    def sync!
      registries_data.each do |registry_data|
        RegistrySync.new(data: registry_data).sync!
      end
    end

    def registries_data
      file_data["@graph"].select do |g|
        g["@type"] == "RegistryEntry"
      end
    end

    def file_data
      @file_data ||= JSON.parse(File.read(filepath))
    end
  end

  class RegistrySync
    attr_reader :data

    def initialize(data:)
      @data = data
    end

    def sync!
      update_node_directory!
    end

    def update_node_directory!
      node_directory.update!(node_directory_attributes)
    end

    def node_directory
      @node_directory ||= NodeDirectory.find_or_initialize_by(external_id: external_id)
    end

    def external_id
      data["@id"]
    end

    def node_directory_attributes
      {
        name: data["name"]["en-us"],
        description: data["description"]["en-us"],
        logo_url: data["registryLogo"],
        pna_url: data["providerNodeAgent"],
        s3_bucket: s3_bucket,
        contact_points: contact_points,
      }
    end

    def s3_bucket
      data[s3_bucket_environment_key]["bucketName"]
    end

    def s3_bucket_environment_key
      Rails.env.production? ? "s3Production" : "s3Test"
    end

    def contact_points
      data["contactPoint"].map do |cp_data|
        node_directory.contact_points.find_or_initialize_by(email: cp_data["email"]).tap do |cp|
          cp.name = cp_data["name"]
          cp.title = cp_data["contactType"]
          cp.save
        end
      end
    end
  end
end
