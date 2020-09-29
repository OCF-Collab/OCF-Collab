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
