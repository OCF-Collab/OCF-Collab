module Api
  class CompetencyFrameworksController < Api::BaseController
    def search
      TransactionLogger.tagged(
        search_params: params[:search],
      ) do
        TransactionLogger.info("Handling competency frameworks search request")

        input = CompetencyFrameworksSearchParamsSanitizer.clean(params.require(:search))

        search = CompetencyFrameworksSearch.new(
          query: input[:query],
          limit: input[:limit],
          includes: [:node_directory],
        )

        render json: {
          search: {
            query: input[:query],
            results: search.results.map { |r|
              CompetencyFrameworkSearchResultRepresenter.new(competency_framework: r).represent
            }
          }
        }

        TransactionLogger.info("Returned competency frameworks search results")
      end
    end

    def show
      TransactionLogger.tagged(
        competenecy_framework_external_id: params[:id],
      ) do
        TransactionLogger.info("Handling competency framework metadata request")

        competency_framework = CompetencyFramework.find_by_external_id!(params[:id])

        render json: CompetencyFrameworkSearchResultRepresenter.new(competency_framework: competency_framework).represent

        TransactionLogger.info("Returned competency framework metadata")
      end
    end

    def asset_file
      TransactionLogger.tagged(
        competency_framework_external_id: params[:id],
        requested_metamodel: params[:metamodel],
      ) do
        TransactionLogger.info("Handling competency framework asset file request")

        competency_framework = CompetencyFramework.find_by_external_id!(params[:id])

        fetcher = CompetencyFrameworkAssetFileFetcher.new(
          competency_framework: competency_framework,
          access_token: doorkeeper_token.token,
          requested_metamodel: params[:metamodel],
        )

        send_data fetcher.body, type: fetcher.content_type, status: 200, disposition: :inline

        TransactionLogger.info("Returned competency framework asset file")
      end
    end
  end
end
