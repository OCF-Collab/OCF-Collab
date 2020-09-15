FactoryBot.define do
  factory :competency_framework do
    transient do
      uuid { Faker::Internet.uuid }
    end

    node_directory
    node_directory_s3_key { "%s.json" % uuid }
    external_id { "https://example.com/%s" % uuid }
    name { Faker::Company.industry }
    description { Faker::Lorem.paragraph }
  end
end
