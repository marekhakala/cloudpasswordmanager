require 'rails_helper'

RSpec.describe 'Directory Entries API', type: :request do
  let(:user_token) { auth_headers(1) }

  describe 'GET /api/v1/directories' do
    before { get api_v1_directory_entries_path, headers: user_token }

    it 'when the directory list info is correct' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:parent_directory_id]).to eq(nil)
      expect(json_response[:current_directory_id]).to eq(1)
      expect(json_response[:current_directory_path].length).to eq(1)
      expect(json_response[:number_passwords]).to eq(2)
      expect(json_response[:directory_entries]).not_to be_empty
      expect(json_response[:directory_entries][:directory_entry]).not_to be_empty
    end

    it 'when the directory path is not empty' do
      expect(json_response[:current_directory_path][0][:label]).to eq("Root")
      expect(json_response[:current_directory_path][0][:parent_directory_id]).to eq(nil)
    end

    it 'when the directory list is not empty' do
      expect(json_response[:directory_entries][:directory_entry][:label]).to eq("Root")
      expect(json_response[:directory_entries][:directory_entry][:number_directories]).to eq(2)
      expect(json_response[:directory_entries][:directory_entry][:number_passwords]).to eq(0)
      expect(json_response[:directory_entries][:directory_entry][:parent_directory_id]).to eq(nil)
      expect(json_response[:directory_entries][:directory_entry][:description]).to eq("Root")
      expect(json_response[:directory_entries][:directory_entry][:directories].length).to eq(2)
    end
  end

  describe 'POST /api/v1/directories' do
    let(:directory_entry_params) { { directory_entry: { label: "Web Hosting", description: "The web hosting passwords.", directory_entry_id: 4 } } }
    before { post api_v1_directory_entries_path, headers: user_token, params: directory_entry_params }

    it 'when the directory entry is not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
      expect(json_response[:result][:directory_entry]).not_to be_empty
      expect(json_response[:result][:directory_entry][:label]).to eq(directory_entry_params[:directory_entry][:label])
      expect(json_response[:result][:directory_entry][:description]).to eq(directory_entry_params[:directory_entry][:description])
      expect(json_response[:result][:directory_entry][:directories]).to eq(nil)
      expect(json_response[:result][:directory_entry][:created_at]).not_to be_empty
    end
  end

  describe 'GET /api/v1/directories/:id' do
    before { get api_v1_directory_entry_path(8), headers: user_token }

    it 'when the directory list info is correct' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:parent_directory_id]).to eq(6)
      expect(json_response[:current_directory_id]).to eq(8)
      expect(json_response[:current_directory_path].length).to eq(4)
      expect(json_response[:directory_entries]).not_to be_empty
      expect(json_response[:directory_entries][:directory_entry]).not_to be_empty
    end

    it 'when the directory path is correct' do
      expect(json_response[:current_directory_path][0][:id]).not_to be_empty
      expect(json_response[:current_directory_path][0][:label]).to eq("Root")
      expect(json_response[:current_directory_path][0][:parent_directory_id]).to eq(nil)

      expect(json_response[:current_directory_path][1][:id]).not_to be_empty
      expect(json_response[:current_directory_path][1][:label]).to eq("General")
      expect(json_response[:current_directory_path][1][:parent_directory_id]).to eq(1)

      expect(json_response[:current_directory_path][2][:id]).not_to be_empty
      expect(json_response[:current_directory_path][2][:label]).to eq("General2")
      expect(json_response[:current_directory_path][2][:parent_directory_id]).to eq(4)

      expect(json_response[:current_directory_path][3][:id]).not_to be_empty
      expect(json_response[:current_directory_path][3][:label]).to eq("General22")
      expect(json_response[:current_directory_path][3][:parent_directory_id]).to eq(6)
    end
  end

  describe 'PATCH /api/v1/directories/:id' do
    let(:directory_entry_update_params) { { directory_entry: { label: "Web Hosting",
      description: "The web hosting password", directory_entry_id: 6 } } }
    before { patch api_v1_directory_entry_path(8), headers: user_token, params: directory_entry_update_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the directory entry have all attributes' do
      expect(json_response[:result][:directory_entry][:id]).to eq(8)
      expect(json_response[:result][:directory_entry][:label]).to eq(directory_entry_update_params[:directory_entry][:label])
      expect(json_response[:result][:directory_entry][:description]).to eq(directory_entry_update_params[:directory_entry][:description])
      expect(json_response[:result][:directory_entry][:created_at]).not_to be_empty
    end
  end

  describe 'PUT /api/v1/directories/:id' do
    let(:directory_entry_update_params) { { directory_entry: { label: "General22",
      description: "The general22 passwords directory.", directory_entry_id: 6 } } }
    before { put api_v1_directory_entry_path(8), headers: user_token, params: directory_entry_update_params }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:result]).not_to be_empty
    end

    it 'when the directory entry have all attributes' do
      expect(json_response[:result][:directory_entry][:id]).to eq(8)
      expect(json_response[:result][:directory_entry][:label]).to eq(directory_entry_update_params[:directory_entry][:label])
      expect(json_response[:result][:directory_entry][:description]).to eq(directory_entry_update_params[:directory_entry][:description])
      expect(json_response[:result][:directory_entry][:created_at]).not_to be_empty
    end
  end

  describe 'DELETE /api/v1/directories/:id' do
    before { delete api_v1_directory_entry_path(11), headers: user_token }

    it 'when the directory entry was deleted successfully' do
      expect(response.status).to eq 200

      get api_v1_directory_entry_path(11), headers: user_token
      expect(json_response[:status]).to eq("failed")
    end
  end

  describe 'GET /api/v1/directories/:id/info' do
    before { get info_api_v1_directory_entry_path(8), headers: user_token }

    it 'when the info attributes are not empty' do
      expect(json_response[:status]).to eq("success")
      expect(json_response[:directory_entry]).not_to be_empty
    end

    it 'when the directory entry have all attributes' do
      expect(json_response[:directory_entry][:id]).to eq(8)
      expect(json_response[:directory_entry][:label]).to eq("General22")
      expect(json_response[:directory_entry][:description]).to eq("The general22 passwords directory.")
    end
  end

  describe 'GET /api/v1/directories/:id/check_directory_label' do
    it 'when the info attributes are not empty' do
      get check_directory_label_api_v1_directory_entry_path(8), headers: user_token, params: { directory_label: "Testing" }

      expect(json_response[:status]).to eq("success")
      expect(json_response[:check_directory_label]).not_to be_empty
      expect(json_response[:check_directory_label][:id]).to eq(nil)
      expect(json_response[:check_directory_label][:unique]).to eq(true)
    end

    it 'when the check directory label have all attributes' do
      get check_directory_label_api_v1_directory_entry_path(8), headers: user_token, params: { directory_label: "General221" }

      expect(json_response[:status]).to eq("success")
      expect(json_response[:check_directory_label]).not_to be_empty
      expect(json_response[:check_directory_label][:id]).not_to eq(nil)
      expect(json_response[:check_directory_label][:unique]).to eq(false)
    end
  end

  describe 'GET /api/v1/directories/:id/check_password_label' do
    it 'when the info attributes are not empty' do
      get check_password_label_api_v1_directory_entry_path(8), headers: user_token, params: { password_label: "Testing" }

      expect(json_response[:status]).to eq("success")
      expect(json_response[:check_password_label]).not_to be_empty
      expect(json_response[:check_password_label][:id]).to eq(nil)
      expect(json_response[:check_password_label][:unique]).to eq(true)
    end

    it 'when the check password label have all attributes' do
      get check_password_label_api_v1_directory_entry_path(8), headers: user_token, params: { password_label: "E-mail" }

      expect(json_response[:status]).to eq("success")
      expect(json_response[:check_password_label]).not_to be_empty
      expect(json_response[:check_password_label][:id]).not_to eq(nil)
      expect(json_response[:check_password_label][:unique]).to eq(false)
    end
  end

  describe 'POST /api/v1/directories/:id/copy_to, /api/v1/directories/:id/move_to, and /api/v1/directories/:id/delete_all' do
    it 'when the directories were moved' do
      post move_to_api_v1_directory_entry_path(11), headers: user_token, params: { move_to_directory: { ids: [15, 16], into: 8 } }
      expect(json_response[:status]).to eq("success")
    end

    it 'when the directories were copied' do
      post move_to_api_v1_directory_entry_path(11), headers: user_token, params: { move_to_directory: { ids: [15, 16], into: 8 } }
      post copy_to_api_v1_directory_entry_path(8), headers: user_token, params: { copy_to_directory: { ids: [15, 16], into: 11 } }
      expect(json_response[:status]).to eq("success")
    end

    it 'when the directories were deleted' do
      post move_to_api_v1_directory_entry_path(11), headers: user_token, params: { move_to_directory: { ids: [15, 16], into: 8 } }
      post copy_to_api_v1_directory_entry_path(8), headers: user_token, params: { copy_to_directory: { ids: [15, 16], into: 11 } }
      post delete_all_api_v1_directory_entry_path(8), headers: user_token, params: { delete_all_directories: { ids: [15, 16] } }
      expect(json_response[:status]).to eq("success")
    end
  end
end
