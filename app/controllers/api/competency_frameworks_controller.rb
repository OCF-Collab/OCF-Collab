module Api
  class CompetencyFrameworksController < Api::BaseController
    def search
      TransactionLogger.info(message: "Initializing search", search_params: params[:search])

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
    end

    def show
      competency_framework = CompetencyFramework.find_by_external_id!(params[:id])

      render json: CompetencyFrameworkSearchResultRepresenter.new(competency_framework: competency_framework).represent
    end

    def asset_file
      competency_framework = CompetencyFramework.find_by_external_id!(params[:id])

      fetcher = CompetencyFrameworkAssetFileFetcher.new(
        competency_framework: competency_framework,
        access_token: doorkeeper_token.token,
        requested_metamodel: params[:metamodel],
      )

      send_data fetcher.body, type: fetcher.content_type, status: 200, disposition: :inline
    end
  end
end
