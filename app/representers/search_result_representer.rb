class SearchResultRepresenter
  attr_reader :search

  def initialize(search:)
    @search = search
  end

  def represent
    search.results.group_by(&:container).map do |container, competencies|
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
      external_id: competency.external_id
    }
  end
end
