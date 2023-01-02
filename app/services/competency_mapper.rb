class CompetencyMapper
  MAPPING_DIR = Rails.root.join("config/competency_mappings")

  attr_reader :body, :competency

  delegate :node_directory, to: :competency

  def initialize(body:, competency:)
    @body = JSON(body)
    @competency = competency
  end

  def transformed_body
    data = properties.map do |property|
      value = body[property.fetch("@id")]
      next unless value

      value = value.values.first if value.is_a?(Hash)
      [property.fetch("rdfs:label"), value]
    end

    { metadata:, properties: data.compact.to_h }.to_json
  end

  private

  def mapping
    filename = "#{node_directory.s3_bucket}.json"
    @mapper ||= JSON(File.read(MAPPING_DIR + filename))
  end

  def metadata
    {
      logo_url: node_directory.logo_url,
      provider_name: node_directory.name,
      title: competency.competency_text
    }
  end

  def properties
    @properties ||= mapping.fetch("@graph").select do |resource|
      resource.fetch("@type") == "rdf:Property" &&
        resource.dig("rdfs:domain", "@id") == "ceasn:Competency"
    end
  end
end
