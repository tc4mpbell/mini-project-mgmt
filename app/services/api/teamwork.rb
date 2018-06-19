class Api::Teamwork
  GET_PERMANENT_TOKEN_URL = "https://www.teamwork.com/launchpad/v1/token.json"

  def initialize project:, user:
    @project      = project
    @user         = user
    @organization = @user.organization

    @tasks = []
  end

  def get_task_lists
    puts "* Getting task lists"
    list_url = teamwork_project_url(@project.teamwork_id, 'tasklists')

    get(list_url)['tasklists']
  end

  def get_tasks
    puts "\n\n* get tasks #{@tasks.count}\n\n"
    tasks_url = teamwork_project_url(@project.teamwork_id, 'tasks')

    params = {}
    # params[:updatedAfterDate] = @project.last_synced_tasks_with_teamwork.strftime("%Y%mdDHMS"))
    
    tasks = get(tasks_url, params, use_cache: !@tasks.empty?)

    if tasks
      @tasks = tasks['todo-items']
    else
      @tasks = []
    end
  end

  def find_or_create_task_list_by_name(name)
    url = teamwork_project_url(@project.teamwork_id, 'tasklists')

    existing_task_list = get_task_lists.find { |list| 
      list['name'] == name 
    }

    return existing_task_list['id'] if existing_task_list

    res = post(url, {
      'todo-list': { name: name }
    })

    return res['TASKLISTID'] if res['STATUS'] == 'OK'
  end

  def add_tasks_to_tasklist(list_id, tasks)
    url = teamwork_url("tasklists/#{list_id}/tasks")

    puts "* adding #{tasks.count} to tasklist #{list_id}"

    tasks.each do |task|
      next if task.teamwork_id.present?
      # already there?
      # throw "in add: #{get_tasks.find{|t| t['id'] == 10724344}}"


      existing_task = get_tasks.find { |tw_task| 
        # puts "IN LOOP"
        # puts "\n* comparing #{tw_task['content']} to #{task.task}\n#{tw_task['content'].strip == task.task.strip}\n"
        tw_task['content'].strip == task.task.strip
      }
      puts "EXISTING TASK #{existing_task}" if existing_task

      if existing_task
        tw_task_id = existing_task['id']
      else
        # not there! GO GO GO
        res = post(url, {
          'todo-item': {
            content: task.task
          }
        })

        puts "* added: #{res.inspect}"
        tw_task_id = res['id']
      end

      task.update(teamwork_id: tw_task_id) if tw_task_id
    end
  end


  def post url, params
    uri = URI(url)

    req = Net::HTTP::Post.new(uri)
    req.body = params.to_json
    req["Content-Type"] = "application/json"
    req['Authorization'] = "Bearer #{@user.teamwork_access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

    throw res
  end

  def get url, params = nil, use_cache: true
    puts "\n\nUSE CACHE #{use_cache}\n\n"
    if use_cache
      Rails.cache.fetch(url, expires_in: 5.minutes) do
        get_uncached(url, params)
      end
    else
      get_uncached(url, params)
    end
  end

  def get_uncached url, params
    puts "UNCACHED GET #{url}"

    uri = URI(url)
    uri.query = URI.encode_www_form(params) if params

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@user.teamwork_access_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
      http.request(req)
    }

    # puts "GET: #{res.body.inspect}"
    
    return JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

    nil
  end

  def teamwork_project_url project_id, to
    "#{@organization.teamwork_api_url}projects/#{project_id}/#{to}.json"
  end

  def teamwork_url to
    "#{@organization.teamwork_api_url}#{to}.json"
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