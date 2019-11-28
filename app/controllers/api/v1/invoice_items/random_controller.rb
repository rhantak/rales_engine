class Api::V1::InvoiceItems::RandomController < ApplicationController
  def show
    random_id = InvoiceItem.pluck(:id).sample(1)
    render json: InvoiceItemSerializer.new(InvoiceItem.find(random_id))
  end
end
