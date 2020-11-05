class CompetencyFrameworkSearchResultRepresenter
  attr_reader :competency_framework

  def initialize(competency_framework:)
    @competency_framework = competency_framework
  end

  def represent
    {
      root_key => {
        "@id" => competency_framework.external_id,
        "title" => competency_framework.name,
        "description" => competency_framework.description,
        "attributionName" => competency_framework.attribution_name,
        "providerMetaModel" => competency_framework.provider_meta_model,
        "attributionLogoUrl" => node_directory.logo_url,
      }
    }
  end

  def root_key
    "framework"
  end

  def node_directory
    competency_framework.node_directory
  end
end
