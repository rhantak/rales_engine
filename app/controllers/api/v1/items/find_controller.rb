class Api::V1::Items::FindController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.order(:id).where(request.query_parameters))
  end

  def show
    render json: ItemSerializer.new(Item.order(:id).find_by(request.query_parameters))
  end


end
