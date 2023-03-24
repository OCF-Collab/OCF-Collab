class ContainerSearchResultRepresenter
  attr_reader :container, :hit_score

  def initialize(container:, hit_score: nil)
    @container = container
    @hit_score = hit_score
  end

  def represent
    {
      "id" => container.external_id,
      "title" => container.name,
      "description" => container.description,
      "attributionName" => container.attribution_name,
      "attributionUrl" => container.attribution_url,
      "attributionLogoUrl" => node_directory.logo_url,
      "providerMetaModel" => container.provider_meta_model,
      "registryRights" => container.registry_rights,
      "beneficiaryRights" => container.beneficiary_rights,
      "hitScore" => hit_score
    }
  end

  def node_directory
    container.node_directory
  end
end
