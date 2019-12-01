class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.most_revenue(limit)
    select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
    joins(:invoice_items, :transactions).
    where(transactions: {result: 'success'}).
    group(:id).
    order('revenue desc').
    limit(limit)
  end

  def best_day
    Item.joins(:invoices, :invoice_items, :transactions).
    select('invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) as revenue').
    group('invoices.created_at').
    where(items: {id: id}).
    merge(Transaction.successful).
    order('revenue desc').
    first
  end
end
