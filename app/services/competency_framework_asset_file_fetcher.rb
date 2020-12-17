require "cgi"

class CompetencyFrameworkAssetFileFetcher
  ASSET_FILE_PATH = "/competency_frameworks/asset_file"

  attr_reader :competency_framework, :access_token, :requested_metamodel

  def initialize(competency_framework:, access_token:, requested_metamodel: nil)
    @competency_framework = competency_framework
    @access_token = access_token
    @requested_metamodel = requested_metamodel
  end

  def body
    if requested_metamodel.blank?
      return pna_response_body
    end

    metamodel_interchanger.transformed_body
  end

  def content_type
    if requested_metamodel.blank?
      return pna_response_content_type
    end

    metamodel_interchanger.transformed_content_type || pna_response_content_type
  end

  private

  def pna_response_body
    pna_response.body
  end

  def pna_response_content_type
    pna_response.headers["content-type"]
  end

  def pna_response
    @pna_response ||= begin
      TransactionLogger.tagged(transaction_logger_tags) do
        TransactionLogger.info(
          message: "Requesting competency framework asset file from PNA",
          event: "competency_framework_asset_file_pna_request",
        )

        connection.get(path, id: competency_framework.external_id).tap do |response|
          TransactionLogger.info(
            message: "Fetched competency framework asset file from PNA",
            event: "competency_framework_asset_file_pna_response",
          )
        end
      end
    end
  end

  def transaction_logger_tags
    {
      competency_framework_id: competency_framework.id,
      competency_framework_external_id: competency_framework.external_id,
      node_directory_id: node_directory.id,
      node_directory_name: node_directory.name,
      node_directory_pna_url: pna_url,
      requested_metamodel: requested_metamodel,
    }
  end


  def connection
    @connection ||= Faraday.new(pna_url, headers: headers) do |c|
      c.use Faraday::Response::RaiseError
    end
  end

  def pna_url
    node_directory.pna_url
  end

  def node_directory
    competency_framework.node_directory
  end

  def headers
    {
      "Authorization" => "Bearer %s" % access_token,
    }
  end

  def path
    ASSET_FILE_PATH
  end

  def metamodel_interchanger
    @metamodel_interchanger ||= CompetencyFrameworkMetamodelInterchanger.new(
      competency_framework: competency_framework,
      competency_framework_body: pna_response_body,
      competency_framework_content_type: pna_response_content_type,
      requested_metamodel: requested_metamodel,
    )
  end
end
