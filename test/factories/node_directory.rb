FactoryBot.define do
  factory :node_directory do
    transient do
      uuid { Faker::Internet.uuid }
    end

    name { Faker::Company.catch_phrase }
    s3_bucket { name.parameterize }
    external_id { "https://example.com/%s" % uuid }
    logo_url { "https://example.com/logos/%s.jpg" % uuid }
  end
end
