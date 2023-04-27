class Search
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100
  MAX_SIZE = 10_000

  attr_reader :container_id, :container_type, :facets, :per_container

  def initialize(
    container_id:,
    container_type:,
    facets:,
    page:,
    per_container:,
    per_page:
  )
    @container_id = container_id
    @container_type = container_type.presence
    @facets = facets
    @page = page
    @per_container = per_container
    @per_page = per_page || DEFAULT_PER_PAGE
  end

  def competencies_count
    containers.map { |c| c["doc_count"] }.sum
  end

  def competency_results
    return [] if containers.none?

    @competency_results ||= begin
      container_ids =
        if container_id.present?
          [container_id]
        else
          containers[(page - 1) * per_page, per_page].map { |c| c["key"] }
        end

      queries = container_ids.map do |container_external_id|
        Competency.search(
          body: {
            query: {
              bool: {
                must: [
                  { bool: { should: { term: { container_external_id: } } } },
                  *query.dig(:bool, :must)
                ],
                should: query.dig(:bool, :should)
              }
            }
          },
          includes: { container: :node_directory },
          load: false,
          per_page: container_id.present? ? MAX_SIZE : per_container
        )
      end

      Searchkick.multi_search(queries)
    end
  end

  def containers_count
    containers.size
  end

  def containers
    @containers ||= begin
      container_query =
        if container_type
          {
            bool: {
              must: [
                { term: { container_type: } },
                *query.dig(:bool, :must)
              ],
              should: query.dig(:bool, :should)
            }
          }
        else
          query
        end

      Competency
        .search(
          body: {
            aggs: {
              containers: {
                terms: {
                  field: :container_external_id,
                  size: MAX_SIZE
                }
              }
            },
            query: container_query,
            size: 0
          },
          per_page: MAX_SIZE
        )
        .aggs
        .dig("containers", "buckets")
    end
  end

  def page
    @page || 1
  end

  def per_page
    return MAX_PER_PAGE if @per_page.nil?

    [@per_page, MAX_PER_PAGE].min
  end

  def query
    @query ||= begin
      optional, required = facets.partition { |f| f[:optional] }

      {
        bool: {
          must: required.map { |f| build_condition(f) },
          should: optional.map { |f| build_condition(f) }
        }
      }
    end
  end

  private

  def build_condition(facet)
    {
      match: { facet[:key] => facet[:value] }
    }
  end
end
