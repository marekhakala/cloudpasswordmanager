module Api::V1
  class DirectoryEntriesController < SecureApiController
    include DirectoryEntriesHelper

    before_action :set_resource, only: [:index, :show]
    before_action :set_directory, only: [:destroy, :info]
    before_action :set_directories, only: [:create, :update]
    before_action :set_user, only: [:check_password_labels, :check_directory_label, :check_password_label, :copy_to, :move_to, :delete_all]

    def index
      render json: { status: :success, parent_directory_id: @parent_directory_id,
        current_directory_id: @current_directory_id,
        current_directory_path: @current_directory_path,
        number_passwords: @number_passwords,
        directory_entries: @resource.as_json }
    end

    def show
      render json: { status: :success, parent_directory_id: @parent_directory_id,
        current_directory_id: @current_directory_id,
        current_directory_path: @current_directory_path,
        number_passwords: @number_passwords,
        directory_entries: @resource.as_json }
    end

    def info
      render json: { status: :success, directory_entry: set_directory_info(@directory_entry) }
    end

    def check_directory_label
      c_params = check_directory_label_params
      check_directory_label_info = Hash.new
      check_directory_label_info["directory_label"] = c_params[:directory_label]

      @directory_entry = @user.directory_entries.find_by!(id: c_params[:id])
      @directory_entry_temp = @directory_entry.directory_entries.find_by(label: c_params[:directory_label])
      check_directory_label_info["id"] = @directory_entry_temp.nil? ? nil : @directory_entry_temp.id
      check_directory_label_info["unique"] = @directory_entry_temp.nil? ? true : false
      render json: { status: :success, check_directory_label: check_directory_label_info }
    end

    def check_password_label
      c_params = check_password_label_params
      check_password_label_info = Hash.new
      check_password_label_info["password_label"] = c_params[:password_label]

      @directory_entry = @user.directory_entries.find_by!(id: c_params[:id])
      @password_entry_temp = @directory_entry.password_entries.find_by(label: c_params[:password_label])
      check_password_label_info["id"] = @password_entry_temp.nil? ? nil : @password_entry_temp.id
      check_password_label_info["unique"] = @password_entry_temp.nil? ? true : false
      render json: { status: :success, check_password_label: check_password_label_info }
    end

    def check_password_labels
      c_params = check_password_labels_params
      check_password_labels_infos = Array.new
      @password_entries = @user.directory_entries.find_by!(id: c_params[:id]).password_entries

      c_params[:ids].each do |idValue|
        password_entry_info_output = Hash.new
        password_entry_info_output["id"] = idValue

        password_entry_info = @password_entries.find_by(id: idValue)
        password_entry_info_output["unique"] = password_entry_info.nil? ? true : false

        unless password_entry_info.nil?
          password_entry_info_output["label"] = password_entry_info.label
          password_entry_info_output["description"] = password_entry_info.description
        end

        check_password_labels_infos << password_entry_info_output
      end

      render json: { status: :success, check_password_labels: check_password_labels_infos }
    end

    def copy_to
      failed_status = false
      output_array = Array.new
      c_params = copy_to_params

      directory_entry_orig = @user.directory_entries.find_by!(id: params[:id])
      directory_entry_into = @user.directory_entries.find_by!(id: c_params[:into])

      unless directory_entry_into.nil?
        c_params[:ids].each do |idValue|
          output_item = Hash.new
          output_item["id"] = idValue

          @password_entry = directory_entry_orig.password_entries.find_by!(id: idValue)
          password_entry_duplicity = directory_entry_into.password_entries.find_by(label: @password_entry.label)

          if not @password_entry.nil? and password_entry_duplicity.nil?
            @password_entry_copy = directory_entry_into.password_entries.new
            @password_entry_copy.label = @password_entry.label
            @password_entry_copy.description = @password_entry.description
            @password_entry_copy.password = @password_entry.password
            @password_entry_copy.account = @password_entry.account
            @password_entry_copy.email = @password_entry.email
            @password_entry_copy.url = @password_entry.url

            output_item["status"] = :success
            output_item["error"] = ""
            @password_entry_copy.save!
          else
            output_item["status"] = :failed
            output_item["error"] = "Can't copy directory #{idValue}."
            failed_status = true unless failed_status
          end

          output_array << output_item
        end
      else
        output_item["status"] = "failed"
        output_item["error"] = "Can't copy directories to directory #{idValue}."
      end

      render json: { status: (failed_status) ? :failed : :success, results: output_array }
    end

    def move_to
      failed_status = false
      output_array = Array.new
      c_params = move_to_params

      directory_entry_orig = @user.directory_entries.find_by!(id: params[:id])
      directory_entry_into = @user.directory_entries.find_by!(id: c_params[:into])

      unless directory_entry_into.nil?
        c_params[:ids].each do |idValue|
          output_item = Hash.new
          output_item["id"] = idValue

          @password_entry = directory_entry_orig.password_entries.find_by!(id: idValue)
          password_entry_duplicity = directory_entry_into.password_entries.find_by(label: @password_entry.label)

          if not @password_entry.nil? and password_entry_duplicity.nil?
            @password_entry.directory_entry = directory_entry_into
            output_item["status"] = :success
            output_item["error"] = ""
            @password_entry.save!
          else
            output_item["status"] = :failed
            output_item["error"] = "Can't move directory #{idValue}."
            failed_status = true unless failed_status
          end

          output_array << output_item
        end
      else
        output_item["status"] = :failed
        output_item["error"] = "Can't move directories to directory #{idValue}."
      end

      render json: { status: (failed_status) ? :failed : :success, results: output_array }
    end

    def delete_all
      failed_status = false
      c_params = delete_all_params
      output_array = Array.new

      @directory_entry = @user.directory_entries.find_by!(id: params[:id])

      c_params[:ids].each do |idValue|
        @password_entry = @directory_entry.password_entries.find_by!(id: idValue)

        output_item = Hash.new
        output_item["id"] = idValue

        if not @password_entry.nil? and @password_entry.destroy
          output_item["status"] = :success
          output_item["errors"] = ""
        else
          output_item["status"] = :failed
          output_item["errors"] = @directory_entry.errors
          failed_status = true unless failed_status
        end

        output_array << output_item
      end

      render json: { status: (failed_status) ? :failed : :success, results: output_array }
    end

    def create
      c_params = directory_entry_params
      @parent_directory = @directory_entries.find_by!(id: c_params[:directory_entry_id])

      unless @parent_directory.nil?
        @directory_entry = @directory_entries.new c_params
      else
        @directory_entry = @directory_entries.new
      end

      if @directory_entry.save
        resource = ActiveModelSerializers::SerializableResource.new @directory_entry
        render json: { status: :success, result: resource.as_json }
      else
        render json: { status: :failed, errors: @directory_entry.errors }
      end
    end

    def update
      c_params = directory_entry_params
      @parent_directory = @directory_entries.find_by!(id: c_params[:directory_entry_id])

      unless @parent_directory.nil?
        @directory_entry = @directory_entries.find_by!(id: params[:id])
      else
        @directory_entry = nil
      end

      if @directory_entry.update c_params
        resource = ActiveModelSerializers::SerializableResource.new @directory_entry
        render json: { status: :success, result: resource.as_json }
      else
        render json: { status: :failed, errors: @directory_entry.errors }
      end
    end

    def destroy
      if not @directory_entry.nil? and not @directory_entry.directory_entry.nil? and @directory_entry.destroy
        render json: { status: :success }
      else
        render json: { status: :failed, errors: @directory_entry.errors }
      end
    end

    private
      def check_directory_label_params
        params.require(:directory_label)
        params.permit(:id, :directory_label)
      end

      def check_password_label_params
        params.require(:password_label)
        params.permit(:id, :password_label)
      end

      def check_password_labels_params
        params.require(:ids)
        params.permit(:id, :ids => [])
      end

      def directory_entry_params
        params.require(:directory_entry).require(:label)
        params.require(:directory_entry).require(:directory_entry_id)
        params.require(:directory_entry).permit(:label, :description, :directory_entry_id)
      end

      def copy_to_params
        params.require(:copy_to_directory).require(:ids)
        params.require(:copy_to_directory).require(:into)
        params.require(:copy_to_directory).permit(:into, :ids => [])
      end

      def move_to_params
        params.require(:move_to_directory).require(:ids)
        params.require(:move_to_directory).require(:into)
        params.require(:move_to_directory).permit(:into, :ids => [])
      end

      def delete_all_params
        params.require(:delete_all_directories).require(:ids)
        params.require(:delete_all_directories).permit(:ids => [])
      end

      def set_directory
        set_user
        @directory_entry = @user.directory_entries.find_by!(id: params[:id])
      end

      def set_directories
        set_user
        @directory_entries = @user.directory_entries
      end

      def set_directory_info directory_entry
        directory_info = Hash.new
        directory_info["id"] = directory_entry.id
        directory_info["label"] = directory_entry.label
        directory_info["description"] = directory_entry.description
        directory_info["number_directories"] = directory_entry.directory_entries.nil? ? 0 : directory_entry.directory_entries.length
        directory_info["number_passwords"] = directory_entry.password_entries.nil? ? 0 : directory_entry.password_entries.length
        directory_info["parent_directory_id"] = directory_entry.directory_entry.nil? ? nil : directory_entry.directory_entry.id
        directory_info
      end

      def set_resource
        set_user
        @root_directory = @user.root_directory
        @resource = ActiveModelSerializers::SerializableResource.new @root_directory

        @total_entries = 0
        @parent_directory_id = nil

        @current_directory = @root_directory
        @current_directory = @user.directory_entries.find_by!(id: params[:id]) if params.has_key?(:id) and not params[:id].nil?

        unless @current_directory.nil?
          @current_directory_id = @current_directory.id
          @parent_directory_id = @current_directory.directory_entry.id if not @current_directory.directory_entry.nil?
          @current_directory_path = current_directory_path @current_directory
          @number_passwords = @current_directory.directory_entries.size
        end
      end

      def set_user
        @user = current_user
      end
  end
end
