class PortalUsersController < ApplicationController
  include PortalUsersHelper

  before_action :set_user
  before_action :set_user_entry, only: [:show, :edit, :update, :destroy]

  def index
    unless @user.role.nil?
      case @user.role.code
        when 'SUPERADMIN1'
          @users = User.joins(:role).where("roles.code = ? or roles.code = ?", "USER1", "ADMIN1")
        when 'ADMIN1'
          @users = User.joins(:role).where("roles.code = ?", "USER1")
        else
          @users  = []
        end
    end
  end

  def show
  end

  def new
    @user_entry = User.new
  end

  def edit
  end

  def create
    c_params = user_params
    permission_check = false
    permission_check = can_manage_role_by_id? c_params[:role_id] unless c_params.nil?

    if not permission_check and not c_params[:role_id].nil? and not c_params[:role_id].empty?
      redirect_to portal_users_path, notice: 'You don\'t have enough privileges to perform this operation.'
    else
      @user_entry = User.new(c_params)
      if @user_entry.save
        redirect_to portal_user_path(@user_entry), notice: 'User was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    c_params = user_params
    permission_check = false
    permission_check = can_manage_role_by_id? c_params[:role_id] unless c_params.nil?

    if not permission_check and not c_params[:role_id].nil? and not c_params[:role_id].empty?
      redirect_to portal_users_path, notice: 'You don\'t have enough privileges to perform this operation.'
    else
      respond_to do |format|
        if @user_entry.update_without_password(c_params)
          format.html { redirect_to portal_user_path(@user_entry), notice: 'User was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    permission_check = false
    permission_check = can_manage_role? @user_entry.role if not @user_entry.nil? and not @user_entry.role.nil?

    unless permission_check
      redirect_to portal_users_path, notice: 'You don\'t have enough privileges to perform this operation.'
    else
      @user_entry.destroy
      respond_to do |format|
        format.html { redirect_to portal_users_path, notice: 'User was successfully destroyed.' }
      end
    end
  end

  private
    def set_user
      @user = current_user
      @minimum_password_length = User.password_length.min
    end

    def set_user_entry
      @user_entry = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:fullname, :email, :address, :role_id, :password)
    end
end
