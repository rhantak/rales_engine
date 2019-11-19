# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'csv'

Rails.application.load_tasks

namespace :import_data do
  task :create_customers => [:environment] do
    file = "data/customers.txt"
    CSV.foreach(file, headers: true) do |row|
      customer_hash = row.to_hash
      Customer.create(customer_hash)
    end
  end

  task :create_merchants => [:environment] do
    file = "data/merchants.txt"
    CSV.foreach(file, headers: true) do |row|
      merchant_hash = row.to_hash
      Merchant.create(merchant_hash)
    end
  end

  task :create_invoices => [:environment] do
    file = "data/invoices.txt"
    CSV.foreach(file, headers: true) do |row|
      invoice_hash = row.to_hash
      Invoice.create(invoice_hash)
    end
  end

  task :create_items => [:environment] do
    file = "data/items.txt"
    CSV.foreach(file, headers: true) do |row|
      item_hash = row.to_hash
      Item.create(item_hash)
    end
  end

  task :create_transactions => [:environment] do
    file = "data/transactions.txt"
    CSV.foreach(file, headers: true) do |row|
      transaction_hash = row.to_hash
      Transaction.create(transaction_hash)
    end
  end

  task :create_invoice_items => [:environment] do
    file = "data/invoice_items.txt"
    CSV.foreach(file, headers: true) do |row|
      invoice_item_hash = row.to_hash
      InvoiceItem.create(invoice_item_hash)
    end
  end

  task create_all: [:create_customers, :create_merchants, :create_items, :create_invoices, :create_transactions, :create_invoice_items]
end
