require 'net/http'

class Api::TeamworkController < ApplicationController
  # Implements: https://developer.teamwork.com/projects/authentication-questions/how-to-authenticate-via-app-login-flow

  GET_PERMANENT_TOKEN_URL = "https://www.teamwork.com/launchpad/v1/token.json"

  # called by teamwork after login with a `code` param
  # containing a temporary key.
  def login
    @temp_key = params[:code]

    get_permanent_token(@temp_key)
  end

  private 

  def get_permanent_token temp_key
    return unless temp_key

    uri = URI(GET_PERMANENT_TOKEN_URL)
    res = Net::HTTP.post uri,
               { code: temp_key }.to_json,
               "Content-Type" => "application/json"

    access_token = JSON.parse(res.body)['access_token']

    throw "Couldn't login to teamwork :(\n\n #{res.body}" unless access_token

    if current_user.update(teamwork_access_token: access_token)
      redirect_to authenticated_root_path
    else
      throw "Couldn't set access token :(\n\n #{res.body}"
    end
  end
end
