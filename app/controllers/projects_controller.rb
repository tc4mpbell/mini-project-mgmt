class ProjectsController < ApplicationController
  def show
    @project = current_organization.projects.find(params[:id])
  end
end
