module Api::V1
  class UsersController < SecureApiController
    include DirectoryEntriesHelper

    before_action :set_user, only: [:index, :directories, :update]

    def index
      resource = ActiveModelSerializers::SerializableResource.new(@user)
      render json: { status: :success, user: resource.as_json[:user] }
    end

    def directories
      directory_array = Array.new
      @user.directory_entries.each do |directory_entry|
        directory_array << { "id": directory_entry.id, "label": directory_entry.label,
          "directory_path": create_directory_path(directory_entry).join("/"),
          "number_directories": directory_entry.directory_entries.nil? ? 0 : directory_entry.directory_entries.length,
          "number_passwords": directory_entry.password_entries.nil? ? 0 : directory_entry.password_entries.length,
          "parent_directory_id": directory_entry.directory_entry.nil? ? nil : directory_entry.directory_entry.id }
      end

      render json: { status: :success, directories: directory_array }
    end

    def update
      if @user.update user_params
        resource = ActiveModelSerializers::SerializableResource.new(@user)
        render json: { status: :success, user: resource.as_json[:user] }
      else
        render json: { status: :failed, errors: @user.errors }
      end
    end

    private
      def set_user
        @user = current_user
      end

      def user_params
        params.require(:user).permit(:fullname, :address)
      end
  end
end
