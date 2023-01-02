class SearchResultRepresenter
  attr_reader :search

  def initialize(search:)
    @search = search
  end

  def represent
    if search.competency_query.blank?
      return search.container_results.map do |container|
        hit_score = search.container_result_hit_scores.fetch(container.id)

        CompetencyFrameworkSearchResultRepresenter
          .new(competency_framework: container, hit_score:)
          .represent
      end
    end

    if search.container_query.blank?
      return search.competency_results.map do |competency|
        container = competency.competency_framework
        hit_score = search.container_result_hit_scores.fetch(container.id)

        container = CompetencyFrameworkSearchResultRepresenter
          .new(competency_framework: container, hit_score:)
          .represent

        { container:, **represent_competency(competency) }
      end
    end

    search.competency_results.group_by(&:competency_framework).map do |container, competencies|
      hit_score = search.container_result_hit_scores.fetch(container.id)

      {
        **CompetencyFrameworkSearchResultRepresenter.new(competency_framework: container, hit_score:).represent,
        competencies: competencies.map { |competency| represent_competency(competency) }
      }
    end
  end

  private

  def represent_competency(competency)
    {
      comment: competency.comment,
      competency_text: competency.competency_text,
      external_id: competency.external_id,
      hit_score: search.competency_result_hit_scores.fetch(competency.id)
    }
  end
end
