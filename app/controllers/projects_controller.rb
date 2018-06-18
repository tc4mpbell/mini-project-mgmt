class ProjectsController < ApplicationController
  def update
    @project = current_organization.projects.find(params[:id])

    if @project.update(project_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {
          render 422
        }
      end
    end
  end

  def show
    @project = current_organization.projects.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:teamwork_id)
  end
end
