class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    Customer.joins(:transactions, :merchants).
    select('merchants.*, count(transactions) as purchases').
    group('merchants.id, customers.id').
    where(customers: {id: id}).
    merge(Transaction.successful).
    order('transactions.count desc').
    first
  end
end
