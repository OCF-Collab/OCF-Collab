require 'test_helper'

class CompetencyFrameworkSearchResultRepresenterTest < ActiveSupport::TestCase
  describe CompetencyFrameworkSearchResultRepresenterTest do
    let(:competency_framework) do
      create(:competency_framework)
    end

    subject do
      CompetencyFrameworkSearchResultRepresenter.new(
        competency_framework: competency_framework,
      )
    end

    describe ".represent" do
      describe "result" do
        let(:result) do
          subject.represent
        end

        it "contains proper id attribute" do
          assert_equal competency_framework.external_id, result["id"]
        end

        it "contains proper title attribute" do
          assert_equal competency_framework.name, result["title"]
        end

        it "contains proper description attribute" do
          assert_equal competency_framework.description, result["description"]
        end

        it "contains proper attributionName attribute" do
          assert_equal competency_framework.attribution_name, result["attributionName"]
        end

        it "contains proper attributionUrl attribute" do
          assert_equal competency_framework.attribution_url, result["attributionUrl"]
        end

        it "contains proper attributionLogoUrl attribute" do
          assert_equal competency_framework.node_directory.logo_url, result["attributionLogoUrl"]
        end

        it "contains proper metamodel attribute" do
          assert_equal competency_framework.provider_meta_model, result["providerMetaModel"]
        end

        it "contains proper registryRights attribute" do
          assert_equal competency_framework.registry_rights, result["registryRights"]
        end

        it "contains proper beneficiaryRights attribute" do
          assert_equal competency_framework.beneficiary_rights, result["beneficiaryRights"]
        end
      end
    end
  end
end
