class CompetencyFrameworksSearch
  MAX_LIMIT = 10

  attr_reader :query, :limit

  def initialize(query:, limit: nil)
    @query = query
    @limit = limit
  end

  def results
    @results ||= CompetencyFramework.search(query, **search_options)
  end

  def search_options
    {
      limit: results_limit,
    }
  end

  def results_limit
    if limit.nil?
      return MAX_LIMIT
    end

    [limit, MAX_LIMIT].min
  end
end
