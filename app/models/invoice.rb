class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.revenue_on_date(target)
    joins(:invoice_items, :transactions).
    where( transactions: {result: :success}).
    where( invoices: {created_at: target.to_date.all_day}).
    sum('quantity * unit_price')
  end
end
