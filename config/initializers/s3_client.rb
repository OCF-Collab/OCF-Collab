S3Client = Aws::S3::Client.new(
  region: ENV["AWS_REGION"],
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  stub_responses: Rails.env.test?,
)
