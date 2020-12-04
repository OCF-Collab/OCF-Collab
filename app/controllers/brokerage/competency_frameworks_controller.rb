module Brokerage
  class CompetencyFrameworksController < Brokerage::BaseController
    def search
      TransactionLogger.tagged(
        search_params: {
          query: params[:query],
          limit: params[:limit],
        },
      ) do
        TransactionLogger.info(
          message: "Handling competency frameworks search request",
          event: "competency_framework_search_request",
        )

        input = sanitize_params!(CompetencyFrameworksSearchParamsSanitizer, params)

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

        TransactionLogger.info(
          message: "Returned competency frameworks search results",
          event: "competency_framework_search_response",
        )
      end
    end

    def metadata
      TransactionLogger.tagged(
        competency_framework_external_id: params[:id],
      ) do
        TransactionLogger.info(
          message: "Handling competency framework metadata request",
          event: "competency_framework_metadata_request",
        )

        input = sanitize_params!(CompetencyFrameworkMetadataParamsSanitizer, params)

        competency_framework = CompetencyFramework.find_by_external_id!(input[:id])

        render json: CompetencyFrameworkSearchResultRepresenter.new(competency_framework: competency_framework).represent

        TransactionLogger.info(
          message: "Returned competency framework metadata",
          event: "competency_framework_metadata_response",
          competency_framework_id: competency_framework.id,
          node_directory_id: competency_framework.node_directory.id,
          node_directory_name: competency_framework.node_directory.name,
        )
      end
    end

    def asset_file
      TransactionLogger.tagged(
        competency_framework_external_id: params[:id],
        requested_metamodel: params[:metamodel],
      ) do
        TransactionLogger.info(
          message: "Handling competency framework asset file request",
          event: "competency_framework_asset_file_request",
        )

        input = sanitize_params!(CompetencyFrameworkAssetFileParamsSanitizer, params)

        competency_framework = CompetencyFramework.find_by_external_id!(input[:id])

        fetcher = CompetencyFrameworkAssetFileFetcher.new(
          competency_framework: competency_framework,
          access_token: doorkeeper_token.token,
          requested_metamodel: input[:metamodel],
        )

        send_data fetcher.body, type: fetcher.content_type, status: 200, disposition: :inline

        TransactionLogger.info(
          message: "Returned competency framework asset file",
          event: "competency_framework_asset_file_response",
          competency_framework_id: competency_framework.id,
          node_directory_id: competency_framework.node_directory.id,
          node_directory_name: competency_framework.node_directory.name,
        )
      end
    end
  end
end
