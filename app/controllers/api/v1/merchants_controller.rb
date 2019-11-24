class Api::V1::MerchantsController < ApplicationController

  def index
    if id = params[:id]
      render json: MerchantSerializer.new(Merchant.where(id: id))
    elsif name = params[:name]
      render json: MerchantSerializer.new(Merchant.where('lower(name) = ?', name.downcase))
    elsif created_at = params[:created_at]
      render json: MerchantSerializer.new(Merchant.where(created_at: created_at))
    elsif updated_at = params[:updated_at]
      render json: MerchantSerializer.new(Merchant.where(updated_at: updated_at))
    else
      render json: MerchantSerializer.new(Merchant.all)
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

  def random
    random_id = Merchant.pluck(:id).sample(1)
    render json: MerchantSerializer.new(Merchant.find(random_id))
  end

  def most_revenue
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def date_revenue
    render json: {data: {attributes: {total_revenue: Invoice.revenue_on_date(params[:date]).to_s}}}
  end

  def favorite_customer
    merchant = Merchant.find(params[:id])
    render json: CustomerSerializer.new(merchant.fave_customer)
  end

end
