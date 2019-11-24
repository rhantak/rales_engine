class Api::V1::ItemsController < ApplicationController

  def index
    if id = params[:id]
      render json: ItemSerializer.new(Item.where(id: id))
    elsif name = params[:name]
      render json: ItemSerializer.new(Item.where('lower(name) = ?', name.downcase))
    elsif description = params[:description]
      render json: ItemSerializer.new(Item.where(description: description))
    elsif unit_price = params[:unit_price]
      render json: ItemSerializer.new(Item.where(unit_price: unit_price))
    elsif created_at = params[:created_at]
      render json: ItemSerializer.new(Item.where(created_at: created_at))
    elsif updated_at = params[:updated_at]
      render json: ItemSerializer.new(Item.where(updated_at: updated_at))
    elsif merchant_id = params[:merchant_id]
      render json: ItemSerializer.new(Item.where(merchant_id: merchant_id).order(id: :asc))
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    if id = params[:id]
      render json: ItemSerializer.new(Item.find(id))
    elsif name = params[:name]
      render json: ItemSerializer.new(Item.find_by('lower(name) = ?', name.downcase))
    elsif description = params[:description]
      render json: ItemSerializer.new(Item.find_by(description: description))
    elsif unit_price = params[:unit_price]
      render json: ItemSerializer.new(Item.find_by(unit_price: unit_price))
    elsif created_at = params[:created_at]
      render json: ItemSerializer.new(Item.order(:id).find_by(created_at: created_at))
    elsif updated_at = params[:updated_at]
      render json: ItemSerializer.new(Item.order(:id).find_by(updated_at: updated_at))
    elsif merchant_id = params[:merchant_id]
      render json: ItemSerializer.new(Item.find_by(merchant_id: merchant_id))
    end
  end

  def random
    random_number = Item.pluck(:id).sample(1)
    render json: ItemSerializer.new(Item.find(random_number))
  end

end
