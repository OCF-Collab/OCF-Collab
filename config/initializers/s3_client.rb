# S3Client = Aws::S3::Client.new(
#   region: ENV["AWS_REGION"],
#   access_key_id: ENV["AWS_ACCESS_KEY_ID"],
#   secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
#   stub_responses: Rails.env.test?,
# )

S3Client = Aws::S3::Client.new(
  region: "us-east-1",
  access_key_id: "AKIAS3RXG6HW2T6OBUNE",
  secret_access_key: "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",
  stub_responses: Rails.env.test?,
)
