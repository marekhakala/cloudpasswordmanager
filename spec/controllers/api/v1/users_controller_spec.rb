require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let(:user_token) { auth_headers(1) }
  let(:admin_token) { auth_headers(2) }
  let(:superadmin_token) { auth_headers(3) }

  describe 'GET /api/v1/user (User)' do
    before { get "/api/v1/user", headers: user_token }

    it 'when the user name is demo@demo.com' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:email]).to eq("demo@demo.com")
    end

    it 'when the user role is set to USER1' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:role][:code]).to eq("USER1")
    end
  end

  describe 'GET /api/v1/user (Admin)' do
    before { get api_v1_user_path, headers: admin_token }

    it 'when the user name is admin@demo.com' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:email]).to eq("admin@demo.com")
    end

    it 'when the user role is set to ADMIN1' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:role][:code]).to eq("ADMIN1")
    end
  end

  describe 'GET /api/v1/user (SuperAdmin)' do
    before { get api_v1_user_path, headers: superadmin_token }

    it 'when the user name is superadmin@demo.com' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:email]).to eq("superadmin@demo.com")
    end

    it 'when the user role is set to SUPERADMIN1' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:role][:code]).to eq("SUPERADMIN1")
    end
  end

  describe 'GET /api/v1/user/directories (User)' do
    before { get api_v1_user_directories_path, headers: user_token }

    it 'when the user directory list is not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:directories]).not_to be_empty
    end
  end

  describe ' PATCH /api/v1/user/update (User)' do
    let(:user_params) { { user: { fullname: "Tester Tester", address: "Tester Ave 1234" } } }
    subject { patch api_v1_user_update_path, params: user_params, headers: user_token }

    it 'when the user was updated' do
      subject
      expect(json_response[:status]).to eq("success")
      expect(json_response[:user][:fullname]).to eq("Tester Tester")
      expect(json_response[:user][:address]).to eq("Tester Ave 1234")
    end
  end
end
