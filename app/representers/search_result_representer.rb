class SearchResultRepresenter
  attr_reader :search

  delegate :competency_results, to: :search

  def initialize(search:)
    @search = search
  end

  def represent
    competency_ids = competency_results.flat_map { |r| r.pluck(:id) }

    competency_hash = Competency
      .where(id: competency_ids)
      .includes(container: :node_directory)
      .map { |c| [c.id, c] }
      .to_h

    represented_competency_results = competency_results.map do |result|
      competencies = result.pluck(:id).map { |id| competency_hash[id] }.compact
      next if competencies.empty?

      container = competencies.first.container

      represented_competencies = competencies.each_with_index.map do |competency, index|
        hit_score = result.hits.dig(index, "_score") unless search.empty?
        represent_competency(competency:, hit_score:)
      end

      {
        **ContainerSearchResultRepresenter.new(container:).represent,
        competencies: represented_competencies,
        total_count: result.total_count
      }
    end

    represented_competency_results.compact
  end

  private

  def represent_competency(competency:, hit_score:)
    {
      comment: competency.comment,
      competency_text: competency.competency_text,
      external_id: competency.external_id,
      hit_score:,
      html_url: competency.html_url
    }
  end
end
