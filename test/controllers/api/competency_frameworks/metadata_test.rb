require "test_helper"

class ApiCompetencyFrameworksMetadataTest < ActionDispatch::IntegrationTest
  describe "GET /competency_frameworks/metadata" do
    let(:id) do
      competency_framework.external_id
    end

    let(:competency_framework) do
      create(:competency_framework)
    end

    context "unauthorized request" do
      it "returns 401" do
        get competency_frameworks_metadata_url(id: id)

        assert_response 401
      end
    end

    context "authorized request" do
      it "returns proper framework metadata" do
        authorized_get(competency_frameworks_metadata_url(id: id))

        assert_response :success

        expected_data = CompetencyFrameworkSearchResultRepresenter.new(competency_framework: competency_framework).represent

        response_data = JSON.parse(@response.body)

        assert_equal expected_data, response_data
      end
    end
  end
end
