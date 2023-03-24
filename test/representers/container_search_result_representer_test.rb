require 'test_helper'

class ContainerSearchResultRepresenterTest < ActiveSupport::TestCase
  describe ContainerSearchResultRepresenterTest do
    let(:container) do
      create(:container)
    end

    subject do
      ContainerSearchResultRepresenter.new(
        container: container,
      )
    end

    describe ".represent" do
      describe "result" do
        let(:result) do
          subject.represent
        end

        it "contains proper id attribute" do
          assert_equal container.external_id, result["id"]
        end

        it "contains proper title attribute" do
          assert_equal container.name, result["title"]
        end

        it "contains proper description attribute" do
          assert_equal container.description, result["description"]
        end

        it "contains proper attributionName attribute" do
          assert_equal container.attribution_name, result["attributionName"]
        end

        it "contains proper attributionUrl attribute" do
          assert_equal container.attribution_url, result["attributionUrl"]
        end

        it "contains proper attributionLogoUrl attribute" do
          assert_equal container.node_directory.logo_url, result["attributionLogoUrl"]
        end

        it "contains proper metamodel attribute" do
          assert_equal container.provider_meta_model, result["providerMetaModel"]
        end

        it "contains proper registryRights attribute" do
          assert_equal container.registry_rights, result["registryRights"]
        end

        it "contains proper beneficiaryRights attribute" do
          assert_equal container.beneficiary_rights, result["beneficiaryRights"]
        end
      end
    end
  end
end
