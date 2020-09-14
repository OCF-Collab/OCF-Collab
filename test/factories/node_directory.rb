FactoryBot.define do
  factory :node_directory do
    name { Faker::Company.catch_phrase }
    s3_bucket { name.parameterize }
  end
end
