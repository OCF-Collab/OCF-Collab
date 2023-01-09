class CompetencyMapper
  MAPPING_DIR = Rails.root.join("config/competency_mappings")

  attr_reader :body, :competency

  delegate :node_directory, to: :competency

  def initialize(body:, competency:)
    @body = JSON(body)
    @competency = competency
  end

  def transformed_body
    converted_properties = properties.map do |property|
      value = body[property.fetch("@id")]
      next unless value

      [property.fetch("rdfs:label"), build_value(value)]
    end

    { metadata:, properties: converted_properties.compact.to_h }.to_json
  end

  private

  def build_value(value)
    return value.map { |v| build_value(v) } if value.is_a?(Array)
    return build_value(value.values.first) if value.is_a?(Hash)

    type = detect_type(value)

    metadata =
      if type == "uri"
        { resource_type: detect_resource_type(value) }
      else
        {}
      end

    {
      type: detect_type(value),
      value:,
      **metadata
    }
  end

  def detect_resource_type(value)
    return "competency" if Competency.exists?(external_id: value)
    return "container" if CompetencyFramework.exists?(external_id: value)
  end

  def detect_type(value)
    return "uri" if valid_uri?(value)

    "string"
  end

  def convert_property(property)
    value = body[property.fetch("@id")]
    return unless value

    [property.fetch("rdfs:label"), build_value(value)]
  end

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

  def valid_uri?(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) && uri.scheme.starts_with?("http")
  rescue URI::InvalidURIError
    false
  end
end
