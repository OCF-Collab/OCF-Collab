class CompetencyMapper
  MAPPING_DIR = Rails.root.join("config/competency_mappings")

  attr_reader :body, :node_directory

  def initialize(body:, node_directory:)
    @body = JSON(body)
    @node_directory = node_directory
  end

  def transformed_body
    data = properties.map do |property|
      value = body[property.fetch("@id")]
      next unless value

      value = value.values.first if value.is_a?(Hash)
      [property.fetch("rdfs:label"), value]
    end

    data.compact.to_h.to_json
  end

  private

  def mapping
    filename = "#{node_directory.s3_bucket}.json"
    @mapper ||= JSON(File.read(MAPPING_DIR + filename))
  end

  def properties
    @properties ||= mapping.fetch("@graph").select do |resource|
      resource.fetch("@type") == "rdf:Property" &&
        resource.dig("rdfs:domain", "@id") == "ceasn:Competency"
    end
  end
end
