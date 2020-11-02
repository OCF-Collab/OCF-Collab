require "cgi"

class CompetencyFrameworkAssetFileFetcher
  ASSET_FILE_PATH = "/competency_frameworks"

  attr_reader :competency_framework, :access_token

  def initialize(competency_framework:, access_token:)
    @competency_framework = competency_framework
    @access_token = access_token
  end

  def body
    pna_response.body
  end

  def content_type
    pna_response.headers["content-type"]
  end

  def status
    pna_response.status
  end

  def pna_response
    @pna_response ||= connection.get(path)
  end

  def connection
    @connection ||= Faraday.new(pna_url, headers: headers)
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
    "%s/%s" % [
      ASSET_FILE_PATH,
      CGI.escape(competency_framework.external_id),
    ]
  end
end
