class SearchController < ApplicationController

  def index
    @node_competencies = NodeCompetency.search(query, page: page, per_page: per_page)
    @node_directories = NodeDirectory.search(query, page: page, per_page: per_page)
    @node_frameworks = NodeFramework.search(query, page: page, per_page: per_page)

    @registry_directories = RegistryDirectory.search(query, page: page, per_page: per_page)
    @registry_entries = RegistryEntry.search(query, page: page, per_page: per_page)
  end

  private

  def query
    params[:search] || '*'
  end

  def per_page
    params[:per_page] || 50
  end

  def page
    params[:page] || 1
  end
end
