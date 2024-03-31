class S3Client < Delegator
  attr_reader :node_directory

  def initialize(node_directory:)
    @node_directory = node_directory
  end

  def __getobj__
    s3_client
  end

  private

  def s3_client
    @s3_client ||= Aws::S3::Client.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: node_directory.s3_region,
      stub_responses: Rails.env.test?,
    )
  end
end
