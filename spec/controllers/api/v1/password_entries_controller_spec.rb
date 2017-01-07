require 'rails_helper'

RSpec.describe 'Password Entries API', type: :request do
  let(:user_token) { auth_headers(1) }

  describe 'GET /api/v1/randompassword (User) Length 8 (Default)' do
    before { get api_v1_randompassword_path, headers: user_token, params: { length: 8 } }

    it 'when the generated password length is 8 characters (default)' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:password].length).to eq(8)
      expect(json_response[:password_length]).to eq(8)
    end
  end

  describe 'GET /api/v1/randompassword (User) Length 10' do
    before { get api_v1_randompassword_path, headers: user_token, params: { length: 10 } }

    it 'when the generated password length is 10 characters' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:password].length).to eq(10)
      expect(json_response[:password_length]).to eq(10)
    end
  end

  describe 'GET /api/v1/directories/:directory_entry_id/passwords' do
    before { get api_v1_directory_entry_password_entries_path(4), headers: user_token }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:total_entries]).to eq(2)
      expect(json_response[:password_entries].length).to eq(2)
    end

    it 'when the first password entry have all attributes' do
      expect(json_response[:password_entries][0][:id]).to eq(1)
      expect(json_response[:password_entries][0][:directory_id]).to eq(4)
      expect(json_response[:password_entries][0][:label]).to eq("E-mail")
      expect(json_response[:password_entries][0][:description]).to eq("My e-mail password")
      expect(json_response[:password_entries][0][:password]).to eq("12345678")
      expect(json_response[:password_entries][0][:account]).to eq("username@myemailbox.com")
      expect(json_response[:password_entries][0][:email]).to eq("username@myemailbox.com")
      expect(json_response[:password_entries][0][:url]).to eq("https://myemailbox.com")
      expect(json_response[:password_entries][0][:created_at]).not_to be_empty
    end
  end

  describe 'POST /api/v1/directories/:directory_entry_id/passwords' do
    let(:password_entry_params) { { password_entry: { directory_id: 4, label: "GamePortal", description: "The GamePortal password",
       password: "iddqd", account: "doommaster", email: "doom@domain.com", url: "https://gameportal.local" } } }
    before { post api_v1_directory_entry_password_entries_path(4), headers: user_token, params: password_entry_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the password entry have all attributes' do
      expect(json_response[:result][:directory_id]).to eq(password_entry_params[:password_entry][:directory_id])
      expect(json_response[:result][:label]).to eq(password_entry_params[:password_entry][:label])
      expect(json_response[:result][:description]).to eq(password_entry_params[:password_entry][:description])
      expect(json_response[:result][:password]).to eq(password_entry_params[:password_entry][:password])
      expect(json_response[:result][:account]).to eq(password_entry_params[:password_entry][:account])
      expect(json_response[:result][:email]).to eq(password_entry_params[:password_entry][:email])
      expect(json_response[:result][:url]).to eq(password_entry_params[:password_entry][:url])
      expect(json_response[:result][:created_at]).not_to be_empty
    end
  end

  describe 'POST /api/v1/directories/:directory_entry_id/passwords/infos' do
    let(:post_data_params) { { password_entries_infos: { ids: [1,2] } } }
    before { post infos_api_v1_directory_entry_password_entries_path(4), headers: user_token, params: post_data_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:password_entries_infos]).not_to be_empty
    end

    it 'when the infos data are not empty' do
      expect(json_response[:password_entries_infos].length).to eq(2)
      expect(json_response[:password_entries_infos][0][:id]).to eq("1")
      expect(json_response[:password_entries_infos][0][:available]).to eq(true)
      expect(json_response[:password_entries_infos][0][:label]).to eq("E-mail")
      expect(json_response[:password_entries_infos][0][:description]).to eq("My e-mail password")
      expect(json_response[:password_entries_infos][1][:id]).to eq("2")
      expect(json_response[:password_entries_infos][1][:available]).to eq(true)
      expect(json_response[:password_entries_infos][1][:label]).to eq("Website portal")
      expect(json_response[:password_entries_infos][1][:description]).to eq("My website password")
    end
  end

  describe 'GET /api/v1/directories/:directory_entry_id/passwords/:id' do
    before { get api_v1_directory_entry_password_entry_path(4, 1), headers: user_token }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the password entry have all attributes' do
      expect(json_response[:result][:id]).to eq(1)
      expect(json_response[:result][:directory_id]).to eq(4)
      expect(json_response[:result][:label]).to eq("E-mail")
      expect(json_response[:result][:description]).to eq("My e-mail password")
      expect(json_response[:result][:password]).to eq("12345678")
      expect(json_response[:result][:account]).to eq("username@myemailbox.com")
      expect(json_response[:result][:email]).to eq("username@myemailbox.com")
      expect(json_response[:result][:url]).to eq("https://myemailbox.com")
      expect(json_response[:result][:created_at]).not_to be_empty
    end
  end

  describe 'PATCH /api/v1/directories/:directory_entry_id/passwords/:id' do
    let(:password_entry_update_params) { { password_entry: { label: "GamePortal", description: "The GamePortal password",
       password: "iddqd", account: "doommaster", email: "doom@domain.com", url: "https://gameportal.local" } } }
    before { patch api_v1_directory_entry_password_entry_path(4, 1), headers: user_token, params: password_entry_update_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the password entry have all attributes' do
      expect(json_response[:result][:id]).to eq(1)
      expect(json_response[:result][:directory_id]).to eq(4)
      expect(json_response[:result][:label]).to eq(password_entry_update_params[:password_entry][:label])
      expect(json_response[:result][:description]).to eq(password_entry_update_params[:password_entry][:description])
      expect(json_response[:result][:password]).to eq(password_entry_update_params[:password_entry][:password])
      expect(json_response[:result][:account]).to eq(password_entry_update_params[:password_entry][:account])
      expect(json_response[:result][:email]).to eq(password_entry_update_params[:password_entry][:email])
      expect(json_response[:result][:url]).to eq(password_entry_update_params[:password_entry][:url])
      expect(json_response[:result][:created_at]).not_to be_empty
    end
  end

  describe 'PUT /api/v1/directories/:directory_entry_id/passwords/:id' do
    let(:password_entry_update_params) { { password_entry: { label: "E-mail", description: "My e-mail password",
       password: "12345678", account: "username@myemailbox.com", email: "username@myemailbox.com", url: "https://myemailbox.com" } } }
    before { patch api_v1_directory_entry_password_entry_path(4, 1), headers: user_token, params: password_entry_update_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the password entry have all attributes' do
      expect(json_response[:result][:id]).to eq(1)
      expect(json_response[:result][:directory_id]).to eq(4)
      expect(json_response[:result][:label]).to eq(password_entry_update_params[:password_entry][:label])
      expect(json_response[:result][:description]).to eq(password_entry_update_params[:password_entry][:description])
      expect(json_response[:result][:password]).to eq(password_entry_update_params[:password_entry][:password])
      expect(json_response[:result][:account]).to eq(password_entry_update_params[:password_entry][:account])
      expect(json_response[:result][:email]).to eq(password_entry_update_params[:password_entry][:email])
      expect(json_response[:result][:url]).to eq(password_entry_update_params[:password_entry][:url])
      expect(json_response[:result][:created_at]).not_to be_empty
    end
  end

  describe 'DELETE /api/v1/directories/:directory_entry_id/passwords/:id' do
    before { delete api_v1_directory_entry_password_entry_path(4, 1), headers: user_token }

    it 'when the password entry was deleted successfully' do
      expect(response.status).to eq 200

      get api_v1_directory_entry_password_entry_path(4, 1), headers: user_token
      expect(json_response[:status]).to eq("failed")
    end
  end
end
