class TasksController < ApplicationController
  def create
    save
  end

  def update
    save
  end


  private

  def find_or_initialize_task
    @project = current_organization.projects.find(params[:task][:project_id])

    @task = params[:id] ? current_organization.all_tasks.find {|task| task.id.to_s == params[:id].to_s } : @project.tasks.new
  end

  def save 
    params[:task][:status] = params[:task][:new_status] unless params[:task][:new_status].blank?

    @task = find_or_initialize_task

    if @task.update(task_params)
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

  def task_params
    params.require(:task).permit(:task, :status, :assignee_id, :category_id)
  end
end
