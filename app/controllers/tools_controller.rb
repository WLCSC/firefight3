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

  def receive
  end

  def receive_post
    @consumable = Consumable.find_by_barcode(params[:barcode])
    if @consumable
      @room = TargetableFinder.call 'Room', params[:room_name]
      if @room
        @stock = Stock.find_or_create_by(consumable_id: @consumable.id, room_id: @room.id) do |s|
          s.count = 0
        end
        @stock.count += 1
        @stock.save
      else
        render js: 'flash("Invalid room!!", "danger")'
      end
    else
      render js: 'flash("Invalid barcode!!", "danger")'
    end
  end

  def use
    if params[:ticket_id].present? && params[:barcode].present?
      @ticket = Ticket.find(params[:ticket_id])
      @consumable = Consumable.find_by_barcode(params[:barcode])
      @room = TargetableFinder.call 'Room', params[:room_name]
      if @ticket && @consumable && @room
        params = {commit: "Use Consumable", room_name: @room.nice_name, consumable_short: @consumable.short, ticket_id: @ticket.id}
        AttachableFactory.call params, current_user
      else
        render js: 'flash("Invalid something!!", "danger")'
      end
    end
  end
end
