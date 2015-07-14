class DashboardController < ApplicationController
  def index
    @alerts = Service.all.to_a
    @alerts.keep_if{|s| !(s.code == 1 || s.overridden?)}
  end

  def jump
    case params[:commit]
    when 'Room'
      redirect_to room_path(Room.find_by_name(params[:room_name].split('/')[1]))
    when 'Building'
      redirect_to Building.find_by_name(params[:building_name])
    when 'User'
      redirect_to user_path(id: User.find(params[:user_sid]).samaccountname)
    when 'Asset'
      redirect_to Asset.find_by_tag(params[:asset_tag])
    when 'Service'
      redirect_to Service.find_by_name(params[:service_name])
    when 'group'
      redirect_to root_path
    end
  end
end
