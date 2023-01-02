class CompetencyFrameworkSearchResultRepresenter
  attr_reader :competency_framework, :hit_score

  def initialize(competency_framework:, hit_score: nil)
    @competency_framework = competency_framework
    @hit_score = hit_score
  end

  def represent
    {
      "id" => competency_framework.external_id,
      "title" => competency_framework.name,
      "description" => competency_framework.description,
      "attributionName" => competency_framework.attribution_name,
      "attributionUrl" => competency_framework.attribution_url,
      "attributionLogoUrl" => node_directory.logo_url,
      "providerMetaModel" => competency_framework.provider_meta_model,
      "registryRights" => competency_framework.registry_rights,
      "beneficiaryRights" => competency_framework.beneficiary_rights,
      "hitScore" => hit_score
    }
  end

  def node_directory
    competency_framework.node_directory
  end
end
