class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
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
