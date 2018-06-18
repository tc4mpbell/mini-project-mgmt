class AddTeamworkApiEndpointUrlToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :teamwork_api_url, :string
  end
end
