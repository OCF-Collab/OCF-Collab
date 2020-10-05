class RequestBroker::ProviderNodeAgentsController < RequestBroker::ApplicationController
  before_action :find_resource

  def show
    respond_to do |wants|
      wants.html
      wants.json { render json: @resource_content }
    end
  end

  private

  def find_resource
    @node_directory = NodeDirectory.find_by(id: params[:id])

    if params.has_key?(:framework_id)
      @resource = NodeFramework.find(params[:framework_id])
      @resource_content = @resource.contents
    end
  end

end
