module Api
  class CompetencyFrameworksController < Api::BaseController
    def search
      input = CompetencyFrameworksSearchParamsSanitizer.clean(params.require(:search))

      search = CompetencyFrameworksSearch.new(
        query: input[:query],
        limit: input[:limit],
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
  end
end
