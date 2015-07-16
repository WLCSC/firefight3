require 'net/ping/external'

class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy, :reassign, :ping]
  before_action :check_for_user, only: [:show, :index]
  before_action :check_for_admin, except: [:show, :index]

  # GET /assets
  # GET /assets.json
  def index
    @assets = Asset.order(:tag).page params[:page]
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)

    respond_to do |format|
      if @asset.save
        format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
        format.json { render :show, status: :created, location: @asset }
      else
        format.html { render :new }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url, notice: 'Asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reassign
    if params[:user_sid].present?
      @asset.targetable = User.find(params[:user_sid])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    elsif params[:group_sid].present?
      @asset.targetable = Group.find(params[:user_sid])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    elsif params[:room_name].present?
      @asset.targetable = Room.find_by_name(params[:room_name].split('/')[1])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    elsif params[:building_name].present?
      @asset.targetable = Building.find_by_name(params[:building_name])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    elsif params[:asset_tag].present?
      @asset.targetable = Asset.find_by_tag(params[:asset_tag])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    elsif params[:service_name].present?
      @asset.targetable = Service.find_by_name(params[:service_name])
      flash[:notice] = "Assigned asset to #{@asset.targetable.name}"
    else
      flash[:alert] = "That's not a thing."
    end
    @asset.save
    redirect_to @asset
  end

  def ping
    @success = @asset.ping
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:tag, :vendor, :history, :serial, :purchase, :cost, :name, :model_n)
    end
end
