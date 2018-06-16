class TasksController < ApplicationController
  def update
    # @TODO authorize
    @task = Task.find(params[:id])

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


  private

  def task_params
    params.require(:task).permit(:task, :status, :assignee_id)
  end
end
