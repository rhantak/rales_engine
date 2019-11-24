class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :merchants

  def self.revenue_on_date(target)
    joins(:invoice_items, :transactions).
    where( transactions: {result: :success}).
    where( invoices: {created_at: target.to_date.all_day}).
    sum('quantity * unit_price')
  end
end
