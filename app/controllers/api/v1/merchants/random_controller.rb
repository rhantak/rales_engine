class Api::V1::Merchants::RandomController < ApplicationController
  def show
    random_id = Merchant.pluck(:id).sample(1)
    render json: MerchantSerializer.new(Merchant.find(random_id))
  end
end
