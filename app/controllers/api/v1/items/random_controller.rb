class Api::V1::Items::RandomController < ApplicationController
  def show
    random_number = Item.pluck(:id).sample(1)
    render json: ItemSerializer.new(Item.find(random_number))
  end
end
