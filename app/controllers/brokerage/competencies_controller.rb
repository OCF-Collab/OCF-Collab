module Brokerage
  class CompetenciesController < Brokerage::BaseController
    def asset_file
      TransactionLogger.tagged(
        competency_framework_external_id: params[:id]
      ) do
        TransactionLogger.info(
          message: "Handling competency framework asset file request",
          event: "competency_framework_asset_file_request",
        )

        input = sanitize_params!(CompetencyAssetFileParamsSanitizer, params)

        competency = Competency.find_by!(external_id: input[:id])

        fetcher = CompetencyAssetFileFetcher.new(
          access_token: doorkeeper_token.token,
          competency:
        )

        mapper = CompetencyMapper.new(body: fetcher.body, competency:)

        send_data mapper.transformed_body,
                  disposition: :inline,
                  type: fetcher.content_type

        TransactionLogger.info(
          message: "Returned competency framework asset file",
          event: "competency_framework_asset_file_response",
          competency_framework_id: competency.id,
          node_directory_id: competency.node_directory.id,
          node_directory_name: competency.node_directory.name,
        )
      end
    end

    def search
      TransactionLogger.tagged(
        search_params: {
          query: params[:query],
          page: params[:page],
          per_page: params[:per_page],
        },
      ) do
        TransactionLogger.info(
          message: "Handling competency frameworks search request",
          event: "competency_framework_search_request",
        )

        input = sanitize_params!(CompetenciesSearchParamsSanitizer, params)

        search = CompetenciesSearch.new(
          container_query: input[:container_query],
          query: input[:query],
          page: input[:page],
          per_page: input[:per_page]
        )

        results = CompetencySearchResultRepresenter
          .new(results: search.competency_results)
          .represent(grouped: search.container_query.present?)

        render json: {
          search: {
            competency_results_count: search.competency_results_count,
            container_query: search.container_query,
            container_results_count: search.container_results_count,
            page: search.page,
            per_page: search.per_page,
            query: search.query,
            results:
          }
        }

        TransactionLogger.info(
          message: "Returned competency frameworks search results",
          event: "competency_framework_search_response",
        )
      end
    end
  end
end
