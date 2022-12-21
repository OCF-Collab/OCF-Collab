class NodeDirectoryEntryParser
  attr_reader :entry_data

  def initialize(entry_data:)
    @entry_data = entry_data
  end

  def parsed_container
    {
      url: container_data["id"],
      name: container_data.dig("name").values.first,
      description: container_data.dig("description")&.values&.first,
      concept_keywords: container_data.dig("conceptKeyword")&.values&.first,
      attribution_name: container_data["attributionName"]&.values&.first,
      attribution_url: container_data["attributionURL"],
      provider_meta_model: container_data["providerMetaModel"],
      beneficiary_rights: container_data["beneficiaryRights"],
      registry_rights: container_data["registryRights"],
      competencies: parsed_competencies,
    }
  end

  private

  def container_data
    entry_data["container"]
  end

  def parsed_competencies
    competencies_data.map do |competency_data|
      {
        competency_text: competency_data["competencyText"].values.first,
        comment: competency_data.dig("comment")&.values&.first&.join("\n"),
        id: competency_data["id"]
      }
    end
  end

  def competencies_data
    entry_data["competencies"]
  end
end
