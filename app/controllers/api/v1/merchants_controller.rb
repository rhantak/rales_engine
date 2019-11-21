class Api::V1::MerchantsController < ApplicationController

  def index
    id = params[:id]
    name = params[:name]
    created_at = params[:created_at]
    updated_at = params[:updated_at]
    if id
      render json: MerchantSerializer.new(Merchant.where(id: id))
    elsif name
      render json: MerchantSerializer.new(Merchant.where('lower(name) = ?', name.downcase))
    elsif created_at
      render json: MerchantSerializer.new(Merchant.where(created_at: created_at))
    elsif updated_at
      render json: MerchantSerializer.new(Merchant.where(updated_at: updated_at))
    else
      render json: MerchantSerializer.new(Merchant.all)
    end
  end

  def show
    name = params[:name]
    created_at = params[:created_at]
    updated_at = params[:updated_at]
    if name
      render json: MerchantSerializer.new(Merchant.find_by('lower(name) = ?', name.downcase))
    elsif created_at
      render json: MerchantSerializer.new(Merchant.find_by(created_at: created_at))
    elsif updated_at
      render json: MerchantSerializer.new(Merchant.find_by(updated_at: updated_at))
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

  def random
    random_id = Merchant.pluck(:id).sample(1)
    render json: MerchantSerializer.new(Merchant.find(random_id))
  end

end
