class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.most_revenue(limit)
    Merchant.select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
    joins(:invoice_items, :transactions).
    group(:id).
    order('revenue desc').
    limit(limit)
    # merge(Transaction.successful).
  end
end
