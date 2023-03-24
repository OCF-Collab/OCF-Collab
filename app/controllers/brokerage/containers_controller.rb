module Brokerage
  class ContainersController < Brokerage::BaseController
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
          event: "container_search_request",
        )

        input = sanitize_params!(ContainerSearchParamsSanitizer, params)

        search = ContainersSearch.new(
          query: input[:query],
          page: input[:page],
          per_page: input[:per_page],
          includes: [:node_directory],
        )

        render json: {
          search: {
            query: search.query,
            per_page: search.per_page,
            page: search.page,
            total_results_count: search.total_results_count,
            results: search.results.map { |r|
              ContainerSearchResultRepresenter.new(container: r).represent
            }
          }
        }

        TransactionLogger.info(
          message: "Returned competency frameworks search results",
          event: "container_search_response",
        )
      end
    end

    def metadata
      TransactionLogger.tagged(
        container_external_id: params[:id],
      ) do
        TransactionLogger.info(
          message: "Handling competency framework metadata request",
          event: "container_metadata_request",
        )

        input = sanitize_params!(ContainerMetadataParamsSanitizer, params)

        container = Container.find_by_external_id!(input[:id])

        render json: ContainerSearchResultRepresenter.new(container:).represent

        TransactionLogger.info(
          message: "Returned competency framework metadata",
          event: "container_metadata_response",
          container_id: container.id,
          node_directory_id: container.node_directory.id,
          node_directory_name: container.node_directory.name,
        )
      end
    end

    def asset_file
      TransactionLogger.tagged(
        container_external_id: params[:id],
        requested_metamodel: params[:metamodel],
      ) do
        TransactionLogger.info(
          message: "Handling competency framework asset file request",
          event: "container_asset_file_request",
        )

        input = sanitize_params!(ContainerAssetFileParamsSanitizer, params)

        container = Container.find_by_external_id!(input[:id])

        fetcher = ContainerAssetFileFetcher.new(
          container: container,
          access_token: doorkeeper_token.token,
          requested_metamodel: input[:metamodel],
        )

        send_data fetcher.body, type: fetcher.content_type, status: 200, disposition: :inline

        TransactionLogger.info(
          message: "Returned competency framework asset file",
          event: "container_asset_file_response",
          container_id: container.id,
          node_directory_id: container.node_directory.id,
          node_directory_name: container.node_directory.name,
        )
      end
    end
  end
end
