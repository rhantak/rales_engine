class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
end
