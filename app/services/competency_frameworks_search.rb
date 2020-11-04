class CompetencyFrameworksSearch
  MAX_LIMIT = 10

  attr_reader :query, :limit, :includes

  def initialize(query:, limit: nil, includes: nil)
    @query = query
    @limit = limit
    @includes = includes
  end

  def results
    @results ||= CompetencyFramework.search(query, **search_options)
  end

  def search_options
    {
      limit: results_limit,
      includes: includes,
      fields: fields,
    }
  end

  def results_limit
    if limit.nil?
      return MAX_LIMIT
    end

    [limit, MAX_LIMIT].min
  end

  def fields
    [
      "name^10",
      "description^5",
      "competencies.name^3",
      "competencies.comment^1",
    ]
  end
end
