require "test_helper"

class ApiCompetencyFrameworksSearchTest < ActionDispatch::IntegrationTest
  describe "GET /search" do
    context "unauthorized request" do
      it "returns 401" do
        get search_api_competency_frameworks_url

        assert_response 401
      end
    end

    context "authorized request" do
      let(:query) do
        "cybersecurity"
      end

      it "returns proper results taking query and limit into account" do
        create(:competency_framework, {
          name: "Cybersecurity Industry Model: U.S. Department of Labor (DOL)",
        })
        cybersecurity1 = create(:competency_framework, {
          name: "NICE Cybersecurity Workforce Framework: Tasks",
          description: "Cybersecurity word in description for higher search score."
        })
        cybersecurity2 = create(:competency_framework, {
          name: "NICE Cybersecurity Workforce Framework: Knowledge",
          description: "Cybersecurity word in description for higher search score. And cybersecurity one more time."
        })
        create(:competency_framework, {
          name: "Building Blocks Model: U.S. Department of Labor (DOL)",
        })

        CompetencyFramework.reindex

        authorized_get(search_api_competency_frameworks_url, params: {
          search: {
            query: query,
            limit: 2,
          }
        })

        assert_response :success

        expected_data = {
          "search" => {
            "query" => query,
            "results" => [
              CompetencyFrameworkSearchResultRepresenter.new(competency_framework: cybersecurity2).represent,
              CompetencyFrameworkSearchResultRepresenter.new(competency_framework: cybersecurity1).represent,
            ]
          }
        }

        response_data = JSON.parse(@response.body)

        assert_equal expected_data, response_data
      end
    end
  end
end
