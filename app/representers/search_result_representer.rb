class SearchResultRepresenter
  attr_reader :search

  def initialize(search:)
    @search = search
  end

  def represent
    if search.competency_query.blank?
      return search.container_results.map do |container|
        CompetencyFrameworkSearchResultRepresenter
          .new(competency_framework: container)
          .represent
      end
    end

    if search.container_query.blank?
      return search.competency_results.map do |competency|
        container = CompetencyFrameworkSearchResultRepresenter
          .new(competency_framework: competency.competency_framework)
          .represent

        { container:, **represent_competency(competency) }
      end
    end

    search.competency_results.group_by(&:competency_framework).map do |container, competencies|
      {
        **CompetencyFrameworkSearchResultRepresenter.new(competency_framework: container).represent,
        competencies: competencies.map { |competency| represent_competency(competency) }
      }
    end
  end

  private

  def represent_competency(competency)
    {
      comment: competency.comment,
      competency_text: competency.competency_text,
      external_id: competency.external_id
    }
  end
end
