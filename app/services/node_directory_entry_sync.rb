class NodeDirectoryEntrySync
  attr_reader :node_directory,
    :s3_key

  def initialize(node_directory:, s3_key:)
    @node_directory = node_directory
    @s3_key = s3_key
  end

  def sync!
    update_container!
  rescue Aws::S3::Errors::NoSuchKey
    delete_existing_container!
  end

  private

  def update_container!
    container.update!(container_attributes)
  end

  def container
    @container ||= CompetencyFramework.find_or_initialize_by(node_directory_s3_key: s3_key) do |container|
      container.node_directory = node_directory
    end
  end

  def parsed_container
    @parsed_container ||= NodeDirectoryEntryParser.new(
      entry_data: entry_data,
    ).parsed_container
  end

  def entry_data
    @entry_data ||= JSON.parse(s3_object_response_body)
  end

  def s3_object_response_body
    @s3_object_resoinse_body = s3_object_response.body.read
  end

  def s3_object_response
    @s3_object_response ||= S3Client.get_object(
      bucket: s3_bucket,
      key: s3_key,
    )
  end

  def s3_bucket
    node_directory.s3_bucket
  end

  def container_attributes
    {
      external_id: parsed_container[:url],
      name: parsed_container[:name],
      description: parsed_container[:description],
      concept_keywords: parsed_container[:concept_keywords],
      attribution_name: parsed_container[:attribution_name],
      attribution_url: parsed_container[:attribution_url],
      provider_meta_model: parsed_container[:provider_meta_model],
      beneficiary_rights: parsed_container[:beneficiary_rights],
      registry_rights: parsed_container[:registry_rights],
      competencies: competencies,
    }
  end

  def competencies
    parsed_container[:competencies].map do |parsed_competency|
      Competency.new(
        competency_text: parsed_competency[:competency_text],
        comment: parsed_competency[:comment],
        external_id: parsed_competency[:id]
      )
    end
  end

  def delete_existing_container!
    CompetencyFramework.find_by(node_directory_s3_key: s3_key)&.destroy
  end
end
