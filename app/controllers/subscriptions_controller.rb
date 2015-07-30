class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]
  before_action :check_for_user

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscriptions = (params[:sid].present? ? User.find(params[:sid]).my_subscriptions : current_user.my_subscriptions)
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
    redirect_to subscriptions_path(sid: @subscription.user_sid)
  end

  # GET /subscriptions/new
  def new
    @subscription = Subscription.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    @subscription = Subscription.new(subscription_params)
    ttype = params[:commit].match(/Subscribe to (\w+)/)[1]
    subs = TargetableFinder.call ttype, params[:sub_id].keep_if{|p| p.present?}.first
    @subscription.subscribable_type = subs.class.to_s
    @subscription.subscribable_id = subs.try(:samaccountname) || subs.id

    respond_to do |format|
      if @subscription.save
        format.html { redirect_to subscriptions_path(sid: @subscription.user_sid), notice: 'Subscription was successfully created.' }
        format.json { render :show, status: :created, location: @subscription }
      else
	flash[:error] = @subscription.errors.full_messages.join ', '
        format.html { render :new }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscriptions/1
  # PATCH/PUT /subscriptions/1.json
  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to subscriptions_path(sid: @subscription.user_sid), notice: 'Subscription was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscription }
      else
        format.html { render :edit }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription.destroy
    respond_to do |format|
      format.html { redirect_to subscriptions_url, notice: 'Subscription was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(:user_sid, :subscribable_id, :subscribable_type)
    end
end
