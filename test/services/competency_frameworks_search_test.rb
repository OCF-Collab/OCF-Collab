require 'test_helper'

class CompetencyFrameworksSearchTest < ActiveSupport::TestCase
  describe CompetencyFrameworksSearch do
    subject do
      CompetencyFrameworksSearch.new(
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
        "competencies.competency_text^3",
        "competencies.comment^1",
      ]
    end

    describe ".results" do
      context "without specified limit" do
        it "returns competency frameworks search results for given query with max limit" do
          verify_search_call(query, {
            limit: CompetencyFrameworksSearch::MAX_LIMIT,
            includes: nil,
            fields: expected_fields,
          })
        end
      end

      context "with specified limit" do
        subject do
          CompetencyFrameworksSearch.new(
            query: query,
            limit: limit,
          )
        end

        context "with specified limit below max" do
          let(:limit) do
            CompetencyFrameworksSearch::MAX_LIMIT - 5
          end

          it "returns competency frameworks search results for given query with provided limit" do
            verify_search_call(query, {
              limit: limit,
              includes: nil,
              fields: expected_fields,
            })
          end
        end

        context "with specified limit above max" do
          let(:limit) do
            CompetencyFrameworksSearch::MAX_LIMIT + 5
          end

          it "returns competency frameworks search results for given query with provided limit" do
            verify_search_call(query, {
              limit: CompetencyFrameworksSearch::MAX_LIMIT,
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
          CompetencyFrameworksSearch.new(
            query: query,
            includes: includes,
          )
        end

        it "passes includes option to Searchkick" do
          verify_search_call(query, {
            limit: CompetencyFrameworksSearch::MAX_LIMIT,
            includes: includes,
            fields: expected_fields,
          })
        end
      end
    end

    def verify_search_call(expected_query, expected_options)
      search_mock = Minitest::Mock.new
      sample_results = [Object.new]

      search_mock.expect(:call, sample_results, [expected_query, expected_options])

      CompetencyFramework.stub(:search, search_mock) do
        results = subject.results

        assert_equal sample_results, results
      end

      search_mock.verify
    end
  end
end
