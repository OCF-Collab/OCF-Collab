require "cgi"

class CompetencyAssetFileFetcher
  ASSET_FILE_PATH = "/competencies/asset_file"

  attr_reader :access_token, :competency

  def initialize(access_token:, competency:)
    @access_token = access_token
    @competency = competency
  end

  def body
    pna_response_body
  end

  def content_type
    pna_response_content_type
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
          event: "container_asset_file_pna_request",
        )

        connection.get(path, id: competency.external_id).tap do |response|
          TransactionLogger.info(
            message: "Fetched competency framework asset file from PNA",
            event: "container_asset_file_pna_response",
          )
        end
      end
    end
  end

  def transaction_logger_tags
    {
      container_id: competency.id,
      container_external_id: competency.external_id,
      node_directory_id: node_directory.id,
      node_directory_name: node_directory.name,
      node_directory_pna_url: pna_url
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
    competency.node_directory
  end

  def headers
    {
      "Authorization" => "Bearer %s" % access_token,
    }
  end

  def path
    ASSET_FILE_PATH
  end
end
