class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def assign
    a = Assignment.create(building_id: params[:building_id], user_sid: params[:user_sid])
    if a.save
      redirect_to user_path(a.user.samaccountname), notice: "Assigned user to building"
    else
      redirect_to user_path(a.user.samaccountname), alert: "Failed to assign user to building"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(:first, params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
