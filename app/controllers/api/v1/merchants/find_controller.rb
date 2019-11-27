class Api::V1::Merchants::FindController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.where(request.query_parameters))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find_by(request.query_parameters))
  end
end
