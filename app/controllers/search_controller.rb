class SearchController < ApplicationController

  def index
    if params.key?(:search)
      per_page = params[:per_page] || 50
      page = params[:page] || 1

      @node_competencies = NodeCompetency.search(params[:search], page: page, per_page: per_page)
      @node_directories = NodeDirectory.search(params[:search], page: page, per_page: per_page)
      @node_frameworks = NodeFramework.search(params[:search], page: page, per_page: per_page)

      @registry_directories = RegistryDirectory.search(params[:search], page: page, per_page: per_page)
      @registry_entries = RegistryEntry.search(params[:search], page: page, per_page: per_page)
    end
  end

end
