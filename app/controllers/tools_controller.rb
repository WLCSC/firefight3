class ToolsController < ApplicationController
  def index
  end

  def checkin
    @asset = Asset.find_by_tag(params[:asset_tag])
    @room = TargetableFinder.call 'Room',params[:room_name]
    if @asset
      if @room
        @previous = @asset.targetable
        @asset.targetable = @room
        @asset.save
      else
        render js: 'flash("Invalid Room!!", "danger");'
      end
    else
        render js: 'flash("Invalid asset!!", "danger");'
    end
  end

  def checkout
    @asset = Asset.find_by_tag(params[:asset_tag])
    @user = User.find_by_stn(params[:user_stn])
    if @asset
      if @user
        @asset.targetable = @user
        @asset.save
      else
        render js: 'flash("Invalid STN!!", "danger");'
      end
    else
      render js: 'flash("Invalid asset!!", "danger");'
    end
  end

  def borrow
  end

  def return
  end

  def print_form
    @asset = Asset.find(params[:asset_id])
    @user = User.find(params[:user_sid])
    render layout: 'print'
  end
end
