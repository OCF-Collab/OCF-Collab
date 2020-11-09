class NodeDirectoryEntrySync
  attr_reader :node_directory,
    :s3_key

  def initialize(node_directory:, s3_key:)
    @node_directory = node_directory
    @s3_key = s3_key
  end

  def sync!
    update_framework!
  rescue Aws::S3::Errors::NoSuchKey
    delete_existing_framework!
  end

  private

  def update_framework!
    competency_framework.update!(framework_attributes)
  end

  def competency_framework
    @competency_framework ||= CompetencyFramework.find_or_initialize_by(node_directory_s3_key: s3_key) do |framework|
      framework.node_directory = node_directory
    end
  end

  def parsed_framework
    @parsed_framework ||= NodeDirectoryEntryParser.new(
      entry_data: entry_data,
    ).parsed_framework
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

  def framework_attributes
    {
      external_id: parsed_framework[:url],
      name: parsed_framework[:name],
      description: parsed_framework[:description],
      concept_keywords: parsed_framework[:concept_keywords],
      attribution_name: parsed_framework[:attribution_name],
      attribution_url: parsed_framework[:attribution_url],
      provider_meta_model: parsed_framework[:provider_meta_model],
      beneficiary_rights: parsed_framework[:beneficiary_rights],
      registry_rights: parsed_framework[:registry_rights],
      competencies: competencies,
    }
  end

  def competencies
    parsed_framework[:competencies].map do |parsed_competency|
      Competency.new(
        competency_text: parsed_competency[:competency_text],
        comment: parsed_competency[:comment],
      )
    end
  end

  def delete_existing_framework!
    CompetencyFramework.find_by(node_directory_s3_key: s3_key)&.destroy
  end
end
