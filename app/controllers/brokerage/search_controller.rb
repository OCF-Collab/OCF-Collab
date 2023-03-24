module Brokerage
  class SearchController < Brokerage::BaseController
    def index
      TransactionLogger.tagged(
        search_params: {
          query: params[:query],
          page: params[:page],
          per_page: params[:per_page],
        },
      ) do
        TransactionLogger.info(
          message: "Handling competency frameworks search request",
          event: "container_search_request",
        )

        input = sanitize_params!(SearchParamsSanitizer, params)

        search = Search.new(
          competency_query: input[:competency_query],
          container_query: input[:container_query],
          page: input[:page],
          per_page: input[:per_page]
        )

        render json: {
          search: {
            competency_query: search.competency_query,
            competency_results_count: search.competency_results_count,
            container_query: search.container_query,
            container_results_count: search.container_results_count,
            page: search.page,
            per_page: search.per_page,
            results: SearchResultRepresenter.new(search:).represent
          }
        }

        TransactionLogger.info(
          message: "Returned competency frameworks search results",
          event: "container_search_response",
        )
      end
    end
  end
end
