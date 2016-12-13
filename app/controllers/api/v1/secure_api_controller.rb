module Api::V1
  class SecureApiController < ActionController::Base
    clear_respond_to
    respond_to :json

    serialization_scope :view_context
    before_action :api_authorize

    rescue_from ActiveRecord::RecordNotFound, with: :record_error
    rescue_from ActiveRecord::ActiveRecordError, with: :record_error
    rescue_from ActionController::ParameterMissing, with: :record_error

    def record_error error
      render json: { status: :failed, errors: error.message }
    end

    def doorkeeper_auth?
      warden.authenticate(scope: :user).nil?
    end

    def setup_session
      unless doorkeeper_auth?
        authenticate_user!
      else
        define_current_user
      end
    end

    def api_authorize
      unless doorkeeper_auth?
        authenticate_user!
      else
        doorkeeper_authorize!
        define_current_user
      end
    end

    def define_current_user
      self.instance_eval do
        def current_user
          @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
        end
      end
    end

    def default_serializer_options
      { root: false }
    end
  end
end
