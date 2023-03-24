require "test_helper"

class ApiContainersSearchTest < ActionDispatch::IntegrationTest
  describe "GET /containers/search" do
    context "unauthorized request" do
      it "returns 401" do
        get containers_search_url

        assert_response 401
      end
    end

    context "authorized request" do
      let(:query) do
        "cybersecurity"
      end

      let(:cybersecurity1) do
        create(:container, {
          name: "NICE Cybersecurity Workforce Framework: Tasks",
          description: "Cybersecurity word in description for higher search score. And cybersecurity one more time. Cybersecurity FTW."
        })
      end

      let(:cybersecurity2) do
        create(:container, {
          name: "NICE Cybersecurity Workforce Framework: Knowledge",
          description: "Cybersecurity word in description for higher search score. And cybersecurity one more time."
        })
      end

      let(:cybersecurity3) do
        create(:container, {
          name: "NICE Cybersecurity Workforce Framework: Skills",
          description: "Cybersecurity word in description for higher search score."
        })
      end

      let(:cybersecurity4) do
        create(:container, {
          name: "NICE Cybersecurity Workforce Framework: Abilities",
          description: "No query word in description this time."
        })
      end

      let(:other) do
        create(:container, {
          name: "Building Blocks Model: U.S. Department of Labor (DOL)",
        })
      end

      let(:frameworks) do
        [
          cybersecurity3,
          cybersecurity1,
          cybersecurity4,
          cybersecurity2,
          other,
        ]
      end

      let(:per_page) do
        2
      end

      before do
        frameworks
        Container.reindex
      end

      context "without page specified" do
        it "returns first items respecting per_page param" do
          authorized_get(containers_search_url, params: {
            query: query,
            per_page: per_page,
          })

          assert_response :success

          expected_data = {
            "search" => {
              "query" => query,
              "per_page" => per_page,
              "page" => 1,
              "total_results_count" => 4,
              "results" => [
                ContainerSearchResultRepresenter.new(container: cybersecurity1).represent,
                ContainerSearchResultRepresenter.new(container: cybersecurity2).represent,
              ]
            }
          }

          response_data = JSON.parse(@response.body)

          assert_equal expected_data, response_data
        end
      end

      context "with page specified" do
        let(:page) do
          2
        end

        it "returns specific page of items respecting per_page param" do
          authorized_get(containers_search_url, params: {
            query: query,
            page: page,
            per_page: per_page,
          })

          assert_response :success

          expected_data = {
            "search" => {
              "query" => query,
              "per_page" => per_page,
              "page" => page,
              "total_results_count" => 4,
              "results" => [
                ContainerSearchResultRepresenter.new(container: cybersecurity3).represent,
                ContainerSearchResultRepresenter.new(container: cybersecurity4).represent,
              ]
            }
          }

          response_data = JSON.parse(@response.body)

          assert_equal expected_data, response_data
        end
      end
    end
  end
end
