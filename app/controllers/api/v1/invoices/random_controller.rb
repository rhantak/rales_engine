class Api::V1::Invoices::RandomController < ApplicationController
  def show
    random_id = Invoice.pluck(:id).sample(1)
    render json: InvoiceSerializer.new(Invoice.find(random_id))
  end
end
