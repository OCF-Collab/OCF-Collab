class ContainersSearch
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  attr_reader :query, :includes

  def initialize(query:, page: nil, per_page: DEFAULT_PER_PAGE, includes: nil)
    @query = query
    @page = page
    @per_page = per_page
    @includes = includes
  end

  def results
    @results ||= Container.search(query, **search_options)
  end

  def total_results_count
    results.total_count
  end

  def search_options
    {
      page: page,
      per_page: per_page,
      includes: includes,
      fields: fields,
    }
  end

  def page
    @page || 1
  end

  def per_page
    if @per_page.nil?
      return MAX_PER_PAGE
    end

    [@per_page, MAX_PER_PAGE].min
  end

  def fields
    [
      "name^10",
      "description^5",
      "concept_keywords^5",
      "competencies.competency_text^3",
      "competencies.comment^1",
    ]
  end
end
