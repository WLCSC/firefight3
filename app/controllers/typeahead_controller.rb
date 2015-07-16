class TypeaheadController < ApplicationController
  def users
    render json: User.find(:all, "*#{params[:query] || ''}*").map{|u| {name: u.samaccountname}}
  end

  def groups
    render json: Group.find(:all, "*#{params[:query] || ''}*").map{|u| {name: u.samaccountname}}
  end

  def listables
    render json: User.find(:all, "*#{params[:query] || ''}*").map{|u| {name: u.samaccountname}} + Group.find(:all, "*#{params[:query] || ''}*").map{|u| {name: "G/" + u.samaccountname}}
  end

  def assets
    render json: Asset.where('tag ilike ?', "%#{params[:query]}%").pluck('tag').map{|c| {name: c}}
  end

  def models
    render json: Model.where('name ilike ?', "%#{params[:query]}%").pluck('name').map{|c| {name: c}}
  end

  def manufacturers
    render json: Model.uniq.where('manufacturer ilike ?', "%#{params[:query]}%").pluck(:manufacturer).map{|c| {name: c}}
  end

  def categories
    render json: Model.uniq.where('category ilike ?', "%#{params[:query]}%").pluck(:category).map{|c| {name: c}}
  end

  def buildings
    render json: Building.where('name ilike ?', "%#{params[:query]}%").pluck('name').map{|c| {name: c}}
  end

  def services
    render json: Service.where('name ilike ?', "%#{params[:query]}%").pluck('name').map{|c| {name: c}}
  end

  def rooms
    render json: Room.where('name ilike ?', "%#{params[:query]}%").map{|c| {name: c.nice_name}}
  end

  def stns
    render json: User.find(:all, filter: {postofficebox: "*#{params[:query] || ''}*"}).map{|u| {name: u.postofficebox}}
  end
end
