require 'test_helper'

class CompetencyFrameworkAssetFileFetcherTest < ActiveSupport::TestCase
  describe CompetencyFrameworkAssetFileFetcher do
    subject do
      CompetencyFrameworkAssetFileFetcher.new(
        competency_framework: competency_framework,
        access_token: access_token.token,
      )
    end

    let(:competency_framework) do
      create(:competency_framework,
        node_directory: node_directory,
        external_id: external_id,
      )
    end

    let(:node_directory) do
      create(:node_directory, pna_url: pna_url)
    end

    let(:external_id) do
      "https://credentialengineregistry.org/graph/ce-001ef2e8-3f11-43b7-9adc-38801341c5b2"
    end

    let(:pna_url) do
      "http://example.com"
    end

    let(:access_token) do
      create(:access_token)
    end

    let(:expected_url) do
      [
        pna_url,
        "competency_frameworks",
        CGI.escape(external_id),
      ].join("/")
    end

    let(:expected_headers) do
      {
        "Authorization": "Bearer %s" % access_token.token,
      }
    end

    context "valid response" do
      before do
        stub_request(:get, expected_url).with(
          headers: expected_headers
        ).to_return(response)
      end

      let(:response) do
        {
          body: response_body,
          headers: response_headers,
          status: 200,
        }
      end

      let(:response_body) do
        file_fixture("competency_frameworks/ce-001ef2e8-3f11-43b7-9adc-38801341c5b2.json").read
      end

      let(:response_headers) do
        {
          "Content-Type" => "application/json"
        }
      end

      describe ".body" do
        it "returns PNA response body" do
          assert_equal response_body, subject.body
        end
      end

      describe ".content_type" do
        it "returns PNA response content type" do
          assert_equal response_headers["Content-Type"], subject.content_type
        end
      end

      describe ".status" do
        it "returns PNA response status" do
          assert_equal response[:status], subject.status
        end
      end
    end
  end
end
