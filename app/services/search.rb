class Search
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  attr_reader :competency_query, :container_query

  def initialize(competency_query:, container_query:, page:, per_page:)
    @competency_query = competency_query
    @container_query = container_query
    @page = page
    @per_page = per_page || DEFAULT_PER_PAGE
  end

  def competency_result_hit_scores
    @competency_result_hit_scores = group_hit_scores(competency_results)
  end

  def competency_results
    @results ||= begin
      options = { fields: competency_fields }

      if container_results&.any?
        container_condition = {
          where: {
            container_id: container_results.pluck(:id)
          }
        }

        options.merge!(
          aggs: { container_id: container_condition },
          includes: { container: :node_directory },
          **container_condition
        )
      else
        options.merge!(search_options)
      end

      Competency.search(competency_query, **options)
    end
  end

  def competency_results_count
    competency_results.total_count
  end

  def container_result_hit_scores
    @container_result_hit_scores = group_hit_scores(container_results)
  end

  def container_results
    return if container_query.blank?

    @container_results ||= Container.search(
      container_query,
      fields: container_fields,
      **search_options
    )
  end

  def container_results_count
    return container_results.total_count unless competency_query.present?

    # competency_results.aggs.dig("container_id", "buckets").size
    competency_results.total_count
  end

  def search_options
    { page:, per_page: }
  end

  def page
    @page || 1
  end

  def per_page
    return MAX_PER_PAGE if @per_page.nil?

    [@per_page, MAX_PER_PAGE].min
  end

  private

  def competency_fields
    %w[competency_text^10 comment^5]
  end

  def container_fields
    %w[external_id name]
  end

  def group_hit_scores(results)
    results.hits.map { |hit| [hit.fetch("_id"), hit.fetch("_score")] }.to_h
  end
end
