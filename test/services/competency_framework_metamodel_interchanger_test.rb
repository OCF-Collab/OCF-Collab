require 'test_helper'

class CompetencyFrameworkMetamodelInterchangerTest < ActiveSupport::TestCase
  METAMODELS = [
    {
      mi_key: "ctdl/asn",
      concept_url: "https://ocf-collab.org/concepts/f9a2b710-1cc4-4065-85fd-596b3c40906c",
    }, {
      mi_key: "case",
      concept_url: "https://ocf-collab.org/concepts/f63b9a67-543a-49ab-b5ed-8296545c1db5",
    }, {
      mi_key: "asn",
      concept_url: "https://ocf-collab.org/concepts/6ad27cff-5832-4b3d-bd3e-892208b80cad",
    }
  ]

  describe CompetencyFrameworkMetamodelInterchanger do
    subject do
      CompetencyFrameworkMetamodelInterchanger.new(
        competency_framework: competency_framework,
        competency_framework_body: original_body,
        competency_framework_content_type: original_content_type,
        requested_metamodel: requested_metamodel,
      )
    end

    let(:competency_framework) do
      create(:competency_framework, {
        provider_meta_model: provider_metamodel,
      })
    end

    let(:original_body) do
      "Body: %s" % provider_metamodel
    end

    let(:original_content_type) do
      "original-content-type"
    end

    context "same provider and requested metamodel" do
      METAMODELS.each do |mm|
        context "%s metamodel" % mm[:mi_key] do
          let(:provider_metamodel) do
            mm[:concept_url]
          end

          let(:requested_metamodel) do
            mm[:concept_url]
          end

          describe ".transformed_body" do
            it "returns original framework body" do
              assert_equal original_body, subject.transformed_body
            end
          end

          describe ".transformed_content_type" do
            it "returns original framework content type" do
              assert_equal original_content_type, subject.transformed_content_type
            end
          end
        end
      end
    end

    context "different provider and requested metamodel" do
      METAMODELS.each do |provider_mm|
        context "%s provider metamodel" % provider_mm[:mi_key] do
          let(:provider_metamodel) do
            provider_mm[:concept_url]
          end

          (METAMODELS - [provider_mm]).each do |requested_mm|
            context "%s requested metamodel" % requested_mm[:mi_key] do
              let(:requested_metamodel) do
                requested_mm[:concept_url]
              end

              let(:expected_mi_url) do
                "%s?from=%s&to=%s" % [
                  CompetencyFrameworkMetamodelInterchanger::METAMODEL_INTERCHANGER_URL,
                  provider_mm[:mi_key],
                  requested_mm[:mi_key],
                ]
              end

              let(:transformed_body) do
                "transformed-body"
              end

              let(:transformed_content_type) do
                "transformed-content-type"
              end

              before do
                stub_request(:post, expected_mi_url).with do |req|
                  req.body.include?("Body: %s" % provider_metamodel) &&
                    req.body.include?("Content-Type: %s" % original_content_type)
                end.to_return(
                  status: 200,
                  body: transformed_body,
                  headers: { "Content-Type": transformed_content_type },
                )
              end

              describe ".transformed_body" do
                it "transforms from provider to requested metamodel" do
                  assert_equal transformed_body, subject.transformed_body
                end
              end

              describe ".transformed_content_type" do
                it "transforms from provider to requested metamodel" do
                  assert_equal transformed_content_type, subject.transformed_content_type
                end
              end
            end
          end
        end
      end
    end
  end
end
