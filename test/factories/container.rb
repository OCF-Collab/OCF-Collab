FactoryBot.define do
  factory :container do
    transient do
      uuid { Faker::Internet.uuid }
    end

    node_directory
    node_directory_s3_key { "%s.json" % uuid }
    external_id { "https://example.com/%s" % uuid }

    name { Faker::Company.industry }
    description { Faker::Lorem.paragraph }

    attribution_name { Faker::Company.name }
    attribution_url { Faker::Internet.url }
    provider_meta_model { Faker::Internet.url }
    beneficiary_rights { Faker::Internet.url }
    registry_rights { Faker::Internet.url }
  end

  factory :competency do
    competency_text { Faker::Job.title }
  end
end
