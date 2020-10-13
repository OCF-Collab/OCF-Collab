class CompetencyFrameworkSearchResultRepresenter
  attr_reader :competency_framework

  def initialize(competency_framework:)
    @competency_framework = competency_framework
  end

  def represent
    {
      root_key => {
        "@id" => attribute(:external_id),
        "name" => attribute(:name),
        "description" => attribute(:description),
        "attributionName" => attribute(:attribution_name),
        "providerLogoUrl" => node_directory.logo_url,
      }
    }
  end

  def root_key
    "framework"
  end

  def attribute(name)
    competency_framework[name]
  end

  def node_directory
    competency_framework.node_directory
  end
end
