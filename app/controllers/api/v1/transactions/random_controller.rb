class Api::V1::Transactions::RandomController < ApplicationController
  def show
    random_id = Transaction.pluck(:id).sample(1)
    render json: TransactionSerializer.new(Transaction.find(random_id))
  end
end
