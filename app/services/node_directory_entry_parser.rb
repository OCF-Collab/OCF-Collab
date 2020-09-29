class NodeDirectoryEntryParser
  attr_reader :entry_data

  def initialize(entry_data:)
    @entry_data = entry_data
  end

  def parsed_framework
    {
      id: framework_id,
      name: framework_data["name"],
      description: framework_data["description"],
      concept_keywords: framework_data["conceptKeyword"],
      attribution_name: framework_data["attributionName"],
      attribution_url: framework_data["attributionURL"],
      provider_node_agent: framework_data["providerNodeAgent"],
      provider_meta_model: framework_data["providerMetaModel"],
      beneficiary_rights: framework_data["beneficiaryRights"],
      registry_rights: framework_data["registryRights"],
      competencies: parsed_competencies,
    }
  end

  private

  def framework_id
    framework_data["@id"]
  end

  def framework_data
    entry_data["framework"]
  end

  def parsed_competencies
    competencies_data.map do |competency_data|
      {
        competency_text: competency_data["competencyText"],
        comment: competency_data["comment"]&.join("\n"),
      }
    end
  end

  def competencies_data
    entry_data["competencies"]
  end
end
