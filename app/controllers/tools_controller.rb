class ToolsController < ApplicationController
  def index
  end

  def checkin
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
