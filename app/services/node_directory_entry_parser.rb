class NodeDirectoryEntryParser
  attr_reader :entry_data

  def initialize(entry_data:)
    @entry_data = entry_data
  end

  def parsed_framework
    {
      url: framework_data["frameworkURL"],
      name: framework_data.dig("name", "en-us"),
      description: framework_data.dig("description", "en-us"),
      concept_keywords: framework_data.dig("conceptKeyword", "en-us"),
      attribution_name: framework_data["attributionName"],
      attribution_url: framework_data["attributionURL"],
      provider_meta_model: framework_data["providerMetaModel"],
      beneficiary_rights: framework_data["beneficiaryRights"],
      registry_rights: framework_data["registryRights"],
      competencies: parsed_competencies,
    }
  end

  private

  def framework_data
    entry_data["framework"]
  end

  def parsed_competencies
    competencies_data.map do |competency_data|
      {
        competency_text: competency_data.dig("competencyText", "en-us"),
        comment: competency_data.dig("comment", "en-us")&.join("\n"),
      }
    end
  end

  def competencies_data
    entry_data["competencies"]
  end
end
