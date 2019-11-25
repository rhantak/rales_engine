class Api::V1::Merchants::FindController < ApplicationController
  def index
    if id = params[:id]
      render json: MerchantSerializer.new(Merchant.where(id: id))
    elsif name = params[:name]
      render json: MerchantSerializer.new(Merchant.where('lower(name) = ?', name.downcase))
    elsif created_at = params[:created_at]
      render json: MerchantSerializer.new(Merchant.where(created_at: created_at))
    elsif updated_at = params[:updated_at]
      render json: MerchantSerializer.new(Merchant.where(updated_at: updated_at))
    end
  end

  def show
    if name = params[:name]
      render json: MerchantSerializer.new(Merchant.find_by('lower(name) = ?', name.downcase))
    elsif created_at = params[:created_at]
      render json: MerchantSerializer.new(Merchant.find_by(created_at: created_at))
    elsif updated_at = params[:updated_at]
      render json: MerchantSerializer.new(Merchant.find_by(updated_at: updated_at))
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end
end
