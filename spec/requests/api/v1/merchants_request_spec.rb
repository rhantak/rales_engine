require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(3)
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a merchant by its attributes' do
    merchant = Merchant.create(name: 'Schroeder-Jerde')
    get '/api/v1/merchants/find?name=SchrOedEr-Jerde'

    expect(response).to be_successful

    api_merchant = JSON.parse(response.body)

    expect(merchant.id.to_s).to eq(api_merchant["data"]["id"])
  end

  it 'can find all merchants matching an attribute' do
    merchant = Merchant.create(name: 'Schroeder-Jerde')
    merchant2 = Merchant.create(name: 'Schroeder-Jerde')
    get '/api/v1/merchants/find_all?name=SchroeDer-JErde'

    matching_merchants = JSON.parse(response.body)
    expect(response).to be_successful

    expect((matching_merchants["data"]).class).to eq(Array)
    expect(matching_merchants["data"][0]["id"]).to eq(merchant.id.to_s)
    expect(matching_merchants["data"][1]["id"]).to eq(merchant2.id.to_s)
  end

  it "can send a random merchant" do
    create_list(:merchant, 3)

    get '/api/v1/merchants/random'

    expect(response.body).to_not eq("")
  end

  it 'can return a collection of items associated with a merchant' do
    merchant = Merchant.create(name: 'Schroeder-Jerde')
    create_list(:item, 5, merchant_id: merchant.id)
    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(5)
  end

  it 'can return a collection of invoices associated with the merchant' do
    merchant = Merchant.create(name: 'Schroeder-Jerde')
    customer = Customer.create(first_name: 'Ryan', last_name: 'Hantak')
    create_list(:invoice, 4, merchant_id: merchant.id, customer_id: customer.id)
    get "/api/v1/merchants/#{merchant.id}/invoices"

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(4)
  end

  it "can return the top x merchants by revenue" do
    customer = Customer.create(first_name: 'Ryan', last_name: 'Hantak')
    merchant_1 = Merchant.create(name: 'Big Ol Bikes')
    merchant_2 = Merchant.create(name: 'Excellent Electronics')
    merchant_3 = Merchant.create(name: 'Fabulous Furniture')
    item_1 = merchant_1.items.create(name: 'Bicycle', description: 'A bike', unit_price: '143.55')
    item_2 = merchant_2.items.create(name: 'Television', description: 'Large and flatscreen', unit_price: '299.99')
    item_3 = merchant_3.items.create(name: 'Couch', description: 'Fancy leather sectional', unit_price: '999.99')
    invoice_1 = customer.invoices.create(status: 'shipped', merchant_id: merchant_1.id)
    invoice_2 = customer.invoices.create(status: 'shipped', merchant_id: merchant_2.id)
    invoice_3 = customer.invoices.create(status: 'shipped', merchant_id: merchant_3.id)
    invoice_item_1 = invoice_1.invoice_items.create(quantity: 50, unit_price: 143.55, item_id: item_1.id)
    invoice_item_2 = invoice_2.invoice_items.create(quantity: 500, unit_price: 299.99, item_id: item_2.id)
    invoice_item_3 = invoice_3.invoice_items.create(quantity: 2, unit_price: 999.99, item_id: item_3.id)
    transaction_1 = invoice_1.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    transaction_2 = invoice_2.transactions.create(credit_card_number: '234', credit_card_expiration_date: '020395', result: 'success')
    transaction_3 = invoice_3.transactions.create(credit_card_number: '345', credit_card_expiration_date: '030496', result: 'success')

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    top_merchants = JSON.parse(response.body)

    expect(top_merchants["data"].count).to eq(2)
    expect(top_merchants["data"][0]["id"]).to eq(merchant_2.id.to_s)
    expect(top_merchants["data"][1]["id"]).to eq(merchant_1.id.to_s)
  end

  it "can return the total revenue for a date across all merchants" do
    customer = Customer.create(first_name: 'Ryan', last_name: 'Hantak')
    merchant_1 = Merchant.create(name: 'Big Ol Bikes')
    merchant_2 = Merchant.create(name: 'Excellent Electronics')
    merchant_3 = Merchant.create(name: 'Fabulous Furniture')
    item_1 = merchant_1.items.create(name: 'Bicycle', description: 'A bike', unit_price: '143.55')
    item_2 = merchant_2.items.create(name: 'Television', description: 'Large and flatscreen', unit_price: '299.99')
    item_3 = merchant_3.items.create(name: 'Couch', description: 'Fancy leather sectional', unit_price: '999.99')
    invoice_1a = customer.invoices.create(status: 'shipped', merchant_id: merchant_1.id, created_at: '2012-03-25 08:54:09 UTC')
    invoice_1b = customer.invoices.create(status: 'shipped', merchant_id: merchant_1.id, created_at: '2012-03-26 06:54:09 UTC')
    invoice_1c = customer.invoices.create(status: 'shipped', merchant_id: merchant_1.id, created_at: '2012-03-26 07:54:09 UTC')
    invoice_2a = customer.invoices.create(status: 'shipped', merchant_id: merchant_2.id, created_at: '2012-03-25 02:54:09 UTC')
    invoice_2b = customer.invoices.create(status: 'shipped', merchant_id: merchant_2.id, created_at: '2012-03-26 03:54:09 UTC')
    invoice_2c = customer.invoices.create(status: 'shipped', merchant_id: merchant_2.id, created_at: '2012-03-27 04:54:09 UTC')
    invoice_3a = customer.invoices.create(status: 'shipped', merchant_id: merchant_3.id, created_at: '2012-03-27 06:54:09 UTC')
    invoice_3b = customer.invoices.create(status: 'shipped', merchant_id: merchant_3.id, created_at: '2012-03-27 01:54:09 UTC')
    invoice_3c = customer.invoices.create(status: 'shipped', merchant_id: merchant_3.id, created_at: '2012-03-27 07:54:09 UTC')

    invoice_1a.invoice_items.create(quantity: 50, unit_price: 143.55, item_id: item_1.id)
    invoice_1b.invoice_items.create(quantity: 50, unit_price: 143.55, item_id: item_1.id)
    invoice_1c.invoice_items.create(quantity: 50, unit_price: 143.55, item_id: item_1.id)
    invoice_2a.invoice_items.create(quantity: 500, unit_price: 299.99, item_id: item_2.id)
    invoice_2b.invoice_items.create(quantity: 500, unit_price: 299.99, item_id: item_2.id)
    invoice_2c.invoice_items.create(quantity: 500, unit_price: 299.99, item_id: item_2.id)
    invoice_3a.invoice_items.create(quantity: 2, unit_price: 999.99, item_id: item_3.id)
    invoice_3b.invoice_items.create(quantity: 2, unit_price: 999.99, item_id: item_3.id)
    invoice_3c.invoice_items.create(quantity: 2, unit_price: 999.99, item_id: item_3.id)
    invoice_1a.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_1b.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_1c.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_2a.transactions.create(credit_card_number: '234', credit_card_expiration_date: '020395', result: 'success')
    invoice_2b.transactions.create(credit_card_number: '234', credit_card_expiration_date: '020395', result: 'success')
    invoice_2c.transactions.create(credit_card_number: '234', credit_card_expiration_date: '020395', result: 'success')
    invoice_3a.transactions.create(credit_card_number: '345', credit_card_expiration_date: '030496', result: 'success')
    invoice_3b.transactions.create(credit_card_number: '345', credit_card_expiration_date: '030496', result: 'success')
    invoice_3c.transactions.create(credit_card_number: '345', credit_card_expiration_date: '030496', result: 'success')

    get '/api/v1/merchants/revenue?date=2012-03-26'

    expect(response).to be_successful

    revenue = JSON.parse(response.body)

    expect(revenue["data"]["attributes"]["total_revenue"]).to eq("164350.0")
  end

  it "can return the customer with the most successful transactions with a merchant" do
    customer_1 = Customer.create(first_name: 'Ryan', last_name: 'Hantak')
    customer_2 = Customer.create(first_name: 'Bob', last_name: 'G')
    merchant = Merchant.create(name: 'Excellent Electronics')
    invoice_1 = customer_1.invoices.create(status: 'shipped', merchant_id: merchant.id, customer_id: customer_1.id)
    invoice_2 = customer_1.invoices.create(status: 'shipped', merchant_id: merchant.id, customer_id: customer_1.id)
    invoice_3 = customer_2.invoices.create(status: 'shipped', merchant_id: merchant.id, customer_id: customer_2.id)
    invoice_4 = customer_2.invoices.create(status: 'shipped', merchant_id: merchant.id, customer_id: customer_2.id)
    invoice_5 = customer_2.invoices.create(status: 'shipped', merchant_id: merchant.id, customer_id: customer_2.id)
    invoice_1.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_2.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_3.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_4.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')
    invoice_5.transactions.create(credit_card_number: '123', credit_card_expiration_date: '010294', result: 'success')

    get "/api/v1/merchants/#{merchant.id}/favorite_customer"

    expect(response).to be_successful

    favorite = JSON.parse(response.body)

    expect(favorite["data"]["id"]).to eq(customer_2.id.to_s)
  end
end
