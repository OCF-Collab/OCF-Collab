require 'test_helper'

class ContainersSearchTest < ActiveSupport::TestCase
  describe ContainersSearch do
    subject do
      ContainersSearch.new(
        query: query,
      )
    end

    let(:query) do
      "cybersecurity"
    end

    let(:expected_fields) do
      [
        "name^10",
        "description^5",
        "concept_keywords^5",
        "competencies.competency_text^3",
        "competencies.comment^1",
      ]
    end

    describe ".results" do
      context "without query only" do
        it "returns competency frameworks search results for given query with max per_page" do
          verify_search_call(query, {
            per_page: ContainersSearch::DEFAULT_PER_PAGE,
            page: 1,
            includes: nil,
            fields: expected_fields,
          })
        end
      end

      context "with specified pagination params" do
        let(:page) do
          2
        end

        subject do
          ContainersSearch.new(
            query: query,
            page: page,
            per_page: per_page,
          )
        end

        context "with specified per_page below max" do
          let(:per_page) do
            ContainersSearch::MAX_PER_PAGE - 5
          end

          it "returns competency frameworks search results for given query with provided per_page" do
            verify_search_call(query, {
              per_page: per_page,
              page: page,
              includes: nil,
              fields: expected_fields,
            })
          end
        end

        context "with specified per_page above max" do
          let(:per_page) do
            ContainersSearch::MAX_PER_PAGE + 5
          end

          it "returns competency frameworks search results for given query with provided per_page" do
            verify_search_call(query, {
              per_page: ContainersSearch::MAX_PER_PAGE,
              page: page,
              includes: nil,
              fields: expected_fields,
            })
          end
        end
      end

      context "with specified includes" do
        let(:includes) do
          [:node_directory]
        end

        subject do
          ContainersSearch.new(
            query: query,
            includes: includes,
          )
        end

        it "passes includes option to Searchkick" do
          verify_search_call(query, {
            per_page: ContainersSearch::DEFAULT_PER_PAGE,
            page: 1,
            includes: includes,
            fields: expected_fields,
          })
        end
      end
    end

    def verify_search_call(expected_query, expected_options)
      search_mock = Minitest::Mock.new
      sample_results = [Object.new]

      search_mock.expect(:call, sample_results) do |query, **options|
        assert_equal expected_query, query
        assert_equal expected_options, options
        true
      end

      Container.stub(:search, search_mock) do
        results = subject.results

        assert_equal sample_results, results
      end

      search_mock.verify
    end
  end
end
