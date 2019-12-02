class Api::V1::Items::BestDayController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    render json: { data: {attributes: {best_day: item.best_day.created_at.to_date}}}
  end
end
