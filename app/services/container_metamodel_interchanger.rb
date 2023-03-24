class ContainerMetamodelInterchanger
  TIMEOUT_SECONDS = 600
  METAMODEL_INTERCHANGER_URL = "https://dev.cassproject.org/api/transform"
  METAMODEL_KEYS = {
    "https://ocf-collab.org/concepts/f9a2b710-1cc4-4065-85fd-596b3c40906c" => "ctdl/asn",
    "https://ocf-collab.org/concepts/6ad27cff-5832-4b3d-bd3e-892208b80cad" => "asn",
    "https://ocf-collab.org/concepts/f63b9a67-543a-49ab-b5ed-8296545c1db5" => "case",
  }

  attr_reader :container,
    :container_body,
    :container_content_type,
    :requested_metamodel

  def initialize(container:, container_body:, container_content_type:, requested_metamodel:)
    @container = container
    @container_body = container_body
    @container_content_type = container_content_type
    @requested_metamodel = requested_metamodel
  end

  def transformed_body
    if same_metamodel?
      return container_body
    end

    metamodel_interchanger_response.body
  end

  def same_metamodel?
    provider_metamodel == requested_metamodel
  end

  def provider_metamodel
    container.provider_meta_model
  end

  def metamodel_interchanger_response
    @metamodel_interchanger_response ||= begin
      TransactionLogger.tagged(transaction_logger_tags) do
        TransactionLogger.info(
          message: "Requesting competency framework metamodel interchange",
          event: "container_metamodel_interchange_request",
        )

        connection.post do |req|
          req.body = metamodel_interchanger_payload
          req.params = metamodel_interchanger_params
        end.tap do
          TransactionLogger.info(
            message: "Finished competency framework metamodel interchange",
            event: "container_metamodel_interchange_response",
          )
        end
      end
    end
  end

  def transaction_logger_tags
    {
      provider_metamodel: provider_metamodel,
      requested_metamodel: requested_metamodel,
    }
  end

  def connection
    @connection ||= Faraday.new(METAMODEL_INTERCHANGER_URL) do |c|
      c.options[:timeout] = TIMEOUT_SECONDS
      c.request :multipart
      c.request :url_encoded
      c.adapter :net_http
    end
  end

  def metamodel_interchanger_payload
    {
      data: upload_io,
    }
  end

  def upload_io
    @upload_io ||= Faraday::UploadIO.new(file_io, container_content_type)
  end

  def file_io
    @file_io ||= StringIO.new(container_body)
  end

  def metamodel_interchanger_params
    {
      from: provider_metamodel_mi_key,
      to: requested_metamodel_mi_key,
    }
  end

  def provider_metamodel_mi_key
    METAMODEL_KEYS[provider_metamodel]
  end

  def requested_metamodel_mi_key
    METAMODEL_KEYS[requested_metamodel]
  end

  def transformed_content_type
    if same_metamodel?
      return container_content_type
    end

    metamodel_interchanger_response.headers["content-type"]
  end
end
