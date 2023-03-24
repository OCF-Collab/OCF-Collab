require "test_helper"

class ApiContainersAssetFileTest < ActionDispatch::IntegrationTest
  describe "GET /containers/asset_file" do
    let(:id) do
      container.external_id
    end

    let(:container) do
      create(:container)
    end

    context "unauthorized request" do
      it "returns 401" do
        get containers_asset_file_url(id: id)

        assert_response 401
      end
    end

    context "authorized request" do
      let(:access_token) do
        create(:access_token)
      end

      let(:metamodel) do
        "metamodel-id"
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

        it "returns proper framework asset file" do
          fetcher_init_mock = Minitest::Mock.new
          fetcher_mock = Minitest::Mock.new
          fetcher_mock.expect(:body, pna_response_body)
          fetcher_mock.expect(:content_type, pna_response_content_type)

          fetcher_init_mock.expect(:call, fetcher_mock) do |**args|
            assert_equal(
              {
                access_token: access_token.token,
                container:,
                requested_metamodel: metamodel
              },
              args
            )
          end

          ContainerAssetFileFetcher.stub(:new, fetcher_init_mock) do
            authorized_get(
              containers_asset_file_url(id: id),
              access_token: access_token,
              params: { metamodel: metamodel },
            )

            assert_response :success

            assert_equal 200, @response.status
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
