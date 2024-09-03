class NodeDirectoryEntrySync
  attr_reader :node_directory,
    :s3_key

  def initialize(node_directory:, s3_key:)
    @node_directory = node_directory
    @s3_key = s3_key
  end

  def sync!
    Container.transaction do
      update_contextualizing_objects!
      update_container!
      update_competencies!
    end

    reindex
  rescue Aws::S3::Errors::NoSuchKey
    delete_existing_container!
  end

  private

  def container
    @container ||= node_directory.
      containers.
      find_or_initialize_by(node_directory_s3_key: s3_key)
  end

  def container_attributes
    {
      external_id: parsed_container[:url],
      type: parsed_container[:type],
      name: parsed_container[:name],
      description: parsed_container[:description],
      concept_keywords: parsed_container[:concept_keywords],
      attribution_name: parsed_container[:attribution_name],
      attribution_url: parsed_container[:attribution_url],
      provider_meta_model: parsed_container[:provider_meta_model],
      beneficiary_rights: parsed_container[:beneficiary_rights],
      registry_rights: parsed_container[:registry_rights],
      data_url: parsed_container[:data_url]
    }
  end

  def delete_existing_container!
    Container.find_by(node_directory_s3_key: s3_key)&.delete
  end

  def entry_data
    @entry_data ||= JSON.parse(s3_object_response_body)
  end

  def parsed_container
    @parsed_container ||= NodeDirectoryEntryParser.new(
      entry_data: entry_data,
    ).parsed_container
  end

  def reindex
    container.competencies.includes(contextualizing_objects: :codes).reindex
  end

  def s3_bucket
    node_directory.s3_bucket
  end

  def s3_client
    @s3_client ||= S3Client.new(node_directory:)
  end

  def s3_object_response
    @s3_object_response ||= s3_client.get_object(
      bucket: s3_bucket,
      key: s3_key,
    )
  end

  def s3_object_response_body
    @s3_object_resoinse_body = s3_object_response.body.read
  end

  def update_codes!(parsed_categories)
    parsed_categories.map do |parsed_category|
      code_set = CodeSet
        .create_with(name: parsed_category[:in_code_set])
        .find_or_create_by!(external_id: parsed_category[:in_code_set])

      code_set
        .codes
        .create_with(
          description: parsed_category[:description],
          name: parsed_category[:name] || ""
        )
        .find_or_create_by!(value: parsed_category[:code_value])
    end
  end

  def update_competencies!
    container.competencies.delete_all

    Parallel.each(parsed_container[:competencies]) do |parsed_competency|
      contextualizing_objects = ContextualizingObject.where(
        external_id: Array.wrap(parsed_competency[:contextualized_by])
      )

      external_id = parsed_competency[:id]

      begin
        container
          .competencies
          .create!(
            comment: parsed_competency[:comment],
            competency_category: parsed_competency[:competency_category],
            competency_label: parsed_competency[:competency_label],
            competency_text: parsed_competency[:competency_text],
            contextualizing_objects:,
            external_id:,
            keywords: parsed_competency[:keywords]
          )
      rescue => e
        Airbrake.notify(
          e,
          competency_id: external_id,
          container_id: container.id
        )
      end
    end
  end

  def update_container!
    container.update!(container_attributes)
  end

  def update_contextualizing_objects!
    parsed_container[:contextualizing_objects].map do |parsed_contextualizing_object|
      external_id = parsed_contextualizing_object[:id]
      data_url = parsed_contextualizing_object[:data_url] || external_id

      ContextualizingObject
        .create_with(
          coded_notation: parsed_contextualizing_object[:coded_notation],
          codes: update_codes!(parsed_contextualizing_object[:category]),
          data_url:,
          description: parsed_contextualizing_object[:description],
          name: parsed_contextualizing_object[:name] || "",
          type: parsed_contextualizing_object[:type]
        )
        .find_or_create_by!(external_id:)
    end
  end
end
