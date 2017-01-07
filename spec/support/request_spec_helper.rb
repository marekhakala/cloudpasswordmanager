module RequestSpecHelper
  def json_response
    @json_response ||= JSON.parse(response.body, symbolize_names: true)
  end

  def auth_headers owner_id
    access_token = Doorkeeper::AccessToken.create!(application_id: nil, resource_owner_id: owner_id, expires_in: 2.hours, scopes: 'public')
    { 'Authorization': "Bearer #{access_token.token}" }
  end
end
