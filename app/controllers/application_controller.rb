class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= (session[:udn] ? User.find(session[:udn]) : nil)
  end

  def current_admin
    @current_admin ||= (current_user && current_user.admin?)
  end

  def current_mod
    @current_mod ||= (current_user && current_user.mod?)
  end

  def string_status status
    case status
    when 1
      "Low"
    when 2
      "Routine"
    when 3
      "Urgent"
    when 99
      "Deferred"
    when 100
      "Complete"
    end
  end

    def room_path r
      building_room_path(r.building, r)
    end

  helper_method :string_status, :current_user, :current_admin, :current_mod, :room_path

  private
  def check_for_user
    redirect_to root_path, alert: "Please log in." unless current_user
  end

  def check_for_admin
    redirect_to root_path, alert: "You can't do that" unless current_admin
  end

  def check_for_mod
    redirect_to root_path, alert: "You can't do that" unless current_mod
  end
end
