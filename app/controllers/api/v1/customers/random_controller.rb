class Api::V1::Customers::RandomController < ApplicationController
  def show
    random_id = Customer.pluck(:id).sample(1)
    render json: CustomerSerializer.new(Customer.find(random_id))
  end
end
