require "test_helper"

class ApiContainersMetadataTest < ActionDispatch::IntegrationTest
  describe "GET /containers/metadata" do
    let(:id) do
      container.external_id
    end

    let(:container) do
      create(:container)
    end

    context "unauthorized request" do
      it "returns 401" do
        get containers_metadata_url(id: id)

        assert_response 401
      end
    end

    context "authorized request" do
      it "returns proper framework metadata" do
        authorized_get(containers_metadata_url(id: id))

        assert_response :success

        expected_data = ContainerSearchResultRepresenter.new(container: container).represent

        response_data = JSON.parse(@response.body)

        assert_equal expected_data, response_data
      end
    end
  end
end
