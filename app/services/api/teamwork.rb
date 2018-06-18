class Api::Teamwork
  GET_PERMANENT_TOKEN_URL = "https://www.teamwork.com/launchpad/v1/token.json"

  def initialize project:, user:
    @project      = project
    @user         = user
    @organization = @user.organization
  end

  def get_task_lists
    list_url = teamwork_url(@project.teamwork_id, 'tasklists')

    get(list_url)['tasklists']
  end

  def get_tasks
    tasks_url = teamwork_url(@project.teamwork_id, 'tasks')

    params = {}
    params[:updatedAfterDate] = @project.last_synced_tasks_with_teamwork
    
    tasks = get(tasks_url, params)

    puts "TASKS #{tasks.inspect}"

    tasks['todo-items']
  end

  def create type, params
    url = teamwork_url(@project.teamwork_id, type)

    post(url, params)
  end

  def post url, params
    uri = URI(GET_PERMANENT_TOKEN_URL)
    # res = Net::HTTP.post uri,
    #            params.to_json,
    #            {"Content-Type": "application/json",
    #            'Authorization': "Bearer #{@user.teamwork_access_token}"}
    
  
    req = Net::HTTP::Post.new(uri)
    # req.set_form_data(params)
    # req["Content-Type"] = "application/json"
    req['Authorization'] = "Bearer #{@user.teamwork_access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    puts "AFTER POST #{res.body.inspect}"
    JSON.parse(res.body)
  end

  def get url, params = nil
    puts "TASK URL: #{url}"
    uri = URI(url)
    uri.query = URI.encode_www_form(params) if params

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@user.teamwork_access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
      http.request(req)
    }

    puts "GET: #{res.body.inspect}"
    
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

    nil
  end

  def teamwork_url project_id, to
    "#{@organization.teamwork_api_url}projects/#{project_id}/#{to}.json"
  end

  def get_permanent_token temp_key
    return unless temp_key

    uri = URI(GET_PERMANENT_TOKEN_URL)
    res = Net::HTTP.post uri,
               { code: temp_key }.to_json,
               "Content-Type" => "application/json"
    
    JSON.parse(res.body)
  end
end