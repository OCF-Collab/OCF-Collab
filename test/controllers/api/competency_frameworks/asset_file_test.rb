require "test_helper"

class ApiCompetencyFrameworksAssetFileTest < ActionDispatch::IntegrationTest
  describe "GET /:id/asset_file" do
    let(:id) do
      competency_framework.external_id
    end

    let(:competency_framework) do
      create(:competency_framework)
    end

    context "unauthorized request" do
      it "returns 401" do
        get asset_file_api_competency_framework_url(id: id)

        assert_response 401
      end
    end

    context "authorized request" do
      let(:access_token) do
        create(:access_token)
      end

      context "valid response" do
        let(:pna_response_status) do
          200
        end

        let(:pna_response_body) do
          "sample_body"
        end

        let(:pna_response_content_type) do
          "application/json"
        end

        it "returns proper framework metadata" do
          fetcher_init_mock = Minitest::Mock.new
          fetcher_mock = Minitest::Mock.new
          fetcher_mock.expect(:status, pna_response_status)
          fetcher_mock.expect(:body, pna_response_body)
          fetcher_mock.expect(:content_type, pna_response_content_type)

          fetcher_init_mock.expect(:call, fetcher_mock, [{
            competency_framework: competency_framework,
            access_token: access_token.token,
          }])

          CompetencyFrameworkAssetFileFetcher.stub(:new, fetcher_init_mock) do
            authorized_get(asset_file_api_competency_framework_url(id: id), access_token: access_token)

            assert_response :success

            assert_equal pna_response_status, @response.status
            assert_equal pna_response_body, @response.body
            assert_equal pna_response_content_type, @response.content_type
          end

          fetcher_init_mock.verify
          fetcher_mock.verify
        end
      end
    end
  end
end
