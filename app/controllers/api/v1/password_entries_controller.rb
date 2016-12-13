module Api::V1
  class PasswordEntriesController < SecureApiController
    include PasswordEntriesHelper

    before_action :set_password_entries, only: [:index, :create, :infos]
    before_action :set_password_entry, only: [:show, :update, :destroy]

    def index
      resource = ActiveModelSerializers::SerializableResource.new @password_entries
      render json: { status: :success, total_entries: @password_entries.size, password_entries: resource.as_json[:password_entries] }
    end

    def infos
      c_params = password_entries_infos_params
      password_entries_infos_output = Array.new

      c_params[:ids].each do |idValue|
        password_entry_info_output = Hash.new
        password_entry_info_output["id"] = idValue

        password_entry_info = @password_entries.find_by(id: idValue)
        password_entry_info_output["available"] = password_entry_info.nil? ? false : true

        unless password_entry_info.nil?
          password_entry_info_output["label"] = password_entry_info.label
          password_entry_info_output["description"] = password_entry_info.description
        end

        password_entries_infos_output << password_entry_info_output
      end

      render json: { status: :success, password_entries_infos: password_entries_infos_output }
    end

    def update
      if @password_entry.update password_entry_params
        resource = ActiveModelSerializers::SerializableResource.new @password_entry
        render json: { status: :success, result: resource.as_json[:password_entry] }
      else
        render json: { status: :failed, errors: @password_entry.errors }
      end
    end

    def show
      resource = ActiveModelSerializers::SerializableResource.new @password_entry
      render json: { status: :success, result: resource.as_json[:password_entry] }
    end

    def create
      @password_entry = @password_entries.new password_entry_params

      if @password_entry.save
        resource = ActiveModelSerializers::SerializableResource.new @password_entry
        render json: { status: :success, result: resource.as_json[:password_entry] }
      else
        render json: { status: :failed, errors: @password_entry.errors }
      end
    end

    def destroy
      if not @password_entry.nil? and @password_entry.destroy
        render json: { status: :success }
      else
        render json: { status: :failed, errors: @password_entry.errors }
      end
    end

    def randompassword
      length = 0
      default_length = 8

      if not params[:length].nil?
        length = params[:length].to_i
      end

      length = default_length if length < 1
      @new_password = generatePassword length
      render json: { status: :success, password: @new_password, password_length: length }
    end

    private
      def password_entries_infos_params
        params.require(:password_entries_infos).require(:ids)
        params.require(:password_entries_infos).permit(:ids => [])
      end

      def password_entry_params
        params.require(:password_entry).require(:label)
        params.require(:password_entry).require(:password)
        params.require(:password_entry).permit(:label, :description, :password, :account, :email, :url)
      end

      def set_password_entry
        set_password_entries
        @password_entry = @password_entries.find_by!(id: params[:id])
      end

      def set_password_entries
        set_user
        @password_entries = @user.directory_entries.find_by!(id: params[:directory_entry_id]).password_entries
      end

      def set_user
        @user = current_user
      end
  end
end
