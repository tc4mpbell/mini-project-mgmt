require 'net/http'

class Api::TeamworkController < ApplicationController
  # Implements: https://developer.teamwork.com/projects/authentication-questions/how-to-authenticate-via-app-login-flow


  # called by teamwork after login with a `code` param
  # containing a temporary key.
  def login
    @temp_key = params[:code]

    login_response = api.get_permanent_token(@temp_key)
    throw "Couldn't login to teamwork :(\n\n #{login_response}" unless login_response

    access_token = login_response['access_token']
    org_api_url  = login_response['installation']['apiEndPoint']

    current_user.update(teamwork_access_token: access_token)
    current_organization.update(teamwork_api_url: org_api_url)

    redirect_to authenticated_root_path
  end

  def sync_tasks_to_teamwork 
    # find or create a task list for each category
    project.categories.where(teamwork_list_id: nil).each do |unsynced_category|
      list_id = api.find_or_create_task_list_by_name(unsynced_category.name)
      unsynced_category.update!(teamwork_list_id: list_id) if list_id
    end
    
    project.categories.each do |category|
      return unless category.teamwork_list_id
      puts "* syncing category #{category.name}"
      # shoot the tasks over!
      api.add_tasks_to_tasklist(category.teamwork_list_id, category.tasks)
    end

    list_id = api.find_or_create_task_list_by_name("Uncategorized")
    api.add_tasks_to_tasklist(list_id, project.tasks.where(category_id: nil))

    # currently unused
    @project.update!(last_synced_tasks_with_teamwork: DateTime.now)

    redirect_to project
  end


  ####### PRIVATE #######
  private 

  def api 
    @teamwork_api ||= Api::Teamwork.new(project: project, user: current_user)
  end

  def project
    @project = current_organization.projects.find(params[:project_id]) if params[:project_id]
  end

end
