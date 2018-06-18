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
    project.categories.where(teamwork_list_id: nil).first(2).each do |unsynced_category|
      res = api.create('tasklists', {
        'todo-list': { name: unsynced_category.name }
      })
      unsynced_category.update(teamwork_list_id: res['id']) if res
    end

    # puts "LISTS #{lists.inspect}"

    # tasks = api.get_tasks

    # tasks["todo-items"].each do |task|
    #   puts "GOT a TASK #{task.inspect}\n\n\n"
    #   sync_task(task)
    # end

    #@project.update(last_synced_tasks_with_teamwork: DateTime.now.strftime("%Y%mdDHMS"))
  end


  ####### PRIVATE #######
  private 

  def api 
    @teamwork_api ||= Api::Teamwork.new(project: project, user: current_user)
  end

  def project
    @project = current_organization.projects.find(params[:project_id])
  end


  def save_task_to_teamwork task


    #{"id"=>10725052, "canComplete"=>true, "comments-count"=>0, "description"=>"", "has-reminders"=>false, "has-unread-comments"=>false, "private"=>0, "content"=>"File shares", "order"=>2002, "project-id"=>376889, "project-name"=>"Dynex - BRS Utility", "todo-list-id"=>941793, "todo-list-name"=>"Infrastructure", "tasklist-private"=>false, "tasklist-isTemplate"=>false, "status"=>"new", "company-name"=>"Dynex Capital", "company-id"=>618895, "creator-id"=>91928, "creator-firstname"=>"Taylor", "creator-lastname"=>"Campbell", "completed"=>false, "start-date"=>"", "due-date-base"=>"", "due-date"=>"", "created-on"=>"2018-06-15T14:05:40Z", "last-changed-on"=>"2018-06-15T14:05:40Z", "position"=>2002, "estimated-minutes"=>0, "priority"=>"", "progress"=>0, "harvest-enabled"=>false, "parentTaskId"=>"", "lockdownId"=>"", "tasklist-lockdownId"=>"", "has-dependencies"=>0, "has-predecessors"=>0, "hasTickets"=>false, "timeIsLogged"=>"0", "attachments-count"=>0, "predecessors"=>[], "canEdit"=>true, "viewEstimatedTime"=>true, "creator-avatar-url"=>"https://s3.amazonaws.com/TWFiles/93850/userAvatar/tf_27C58479-0302-48BB-E0F3D470C8994245.Taylor2017.png", "canLogTime"=>true, "userFollowingComments"=>false, "userFollowingChanges"=>false, "DLM"=>0}
  end

end
