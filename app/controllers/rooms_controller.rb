class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy, :stock, :restock]
  before_action :set_building
  before_action :check_for_user, only: [:show, :index]
  before_action :check_for_admin, except: [:show, :index]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = @building.rooms.build(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to [@building, @room], notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def stock
    @stocks = @room.stocks
  end

  def restock
    @consumable = Consumable.find_by_short(params[:consumable_short])
    @stock = Stock.find_or_create_by(consumable_id: @consumable.id, room_id: @room.id) do |s|
      s.count = 0
    end

    case params[:modify]
    when 'set'
      @stock.count = params[:count].to_i
    when 'add'
      @stock.count += params[:count].to_i
    when 'remove'
      @stock.count -= params[:count].to_i
    end

    @stock.save
    redirect_to stock_building_room_path(@building, @room)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.friendly.find(params[:id])
    end

    def set_building
      @building = Building.friendly.find(params[:building_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :description, :building)
    end
end
