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
      it "returns hash with proper attributes" do
        result = subject.represent

        expected_data = {
          "framework" => {
            "@id" => competency_framework.external_id,
            "name" => competency_framework.name,
            "description" => competency_framework.description,
            "attributionName" => competency_framework.attribution_name,
            "attributionLogoUrl" => competency_framework.node_directory.logo_url,
          }
        }

        assert_equal expected_data, result
      end
    end
  end
end
