class SearchResultRepresenter
  attr_reader :search

  delegate :competency_hit_scores, :competency_results, to: :search

  def initialize(search:)
    @search = search
  end

  def represent
    competency_results.group_by(&:container).map do |container, competencies|
      {
        **ContainerSearchResultRepresenter.new(container:).represent,
        competencies: competencies.map { |c| represent_competency(c) }
      }
    end
  end

  private

  def represent_competency(competency)
    {
      comment: competency.comment,
      competency_text: competency.competency_text,
      external_id: competency.external_id,
      hit_score: competency_hit_scores.fetch(competency.id)
    }
  end
end
