require 'rails_helper'

describe 'Invoices API' do
  describe 'record endpoints' do
    before(:each) do
      @customer = create(:customer)
    end

    it "sends a list of invoices" do
      create_list(:invoice, 4, customer_id: @customer.id)

      get '/api/v1/invoices'

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers["data"].count).to eq(4)
    end

    it "can get one invoice by its id" do
      id = create(:invoice, customer_id: @customer.id).id

      get "/api/v1/invoices/#{id}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["data"]["id"]).to eq(id.to_s)
    end

    it "can find an invoice by its attributes" do
      invoice_1 = create(:invoice, status: 'pending', customer_id: @customer.id)
      invoice_2 = create(:invoice, status: 'shipped', customer_id: @customer.id)

      get '/api/v1/invoices/find?status=shiPPed'

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["data"]["id"]).to eq(invoice_2.id.to_s)
    end

    it "can find all invoices matching an attribute" do
      invoice_1 = create(:invoice, status: 'pending', customer_id: @customer.id)
      invoice_2 = create(:invoice, status: 'shipped', customer_id: @customer.id)
      invoice_3 = create(:invoice, status: 'shipped', customer_id: @customer.id)

      get '/api/v1/invoices/find_all?status=ShIpPeD'

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices["data"].count).to eq(2)
      expect(invoices["data"][0]["id"]).to eq(invoice_2.id.to_s)
      expect(invoices["data"][1]["id"]).to eq(invoice_3.id.to_s)
    end

    it "can send a random invoice" do
      create_list(:invoice, 4, customer_id: @customer.id)

      get '/api/v1/invoices/random'

      expect(response).to be_successful

      expect(response.body).to_not eq("")
    end
  end

  describe 'relationship endpoints' do
    before(:each) do
      @customer = create(:customer)
      @invoice = create(:invoice, customer_id: @customer.id)
    end

    it "can send a list of transactions related to the invoice" do
      create_list(:transaction, 4, invoice_id: @invoice.id)

      get "/api/v1/invoices/#{@invoice.id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions["data"].count).to eq(4)
    end

    it "can send a list of invoice items related to the invoice" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      create_list(:invoice_item, 3, item_id: item.id, invoice_id: @invoice.id)

      get "/api/v1/invoices/#{@invoice.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].count).to eq(3)
    end

    it "can send a list of items related to the invoice" do
      merchant = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      create(:invoice_item, item_id: item_1.id, invoice_id: @invoice.id)
      create(:invoice_item, item_id: item_2.id, invoice_id: @invoice.id)

      get "/api/v1/invoices/#{@invoice.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items["data"].count).to eq(2)
    end

    it "can send the customer related to the invoice" do
      get "/api/v1/invoices/#{@invoice.id}/customer"

      expect(response).to be_successful

      customer = JSON.parse(response.body)

      expect(customer["data"]["id"]).to eq(@customer.id.to_s)
    end

    it "can send the merchant related to the invoice" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      create_list(:invoice_item, 3, item_id: item.id, invoice_id: @invoice.id)

      get "/api/v1/invoices/#{@invoice.id}/merchant"

      expect(response).to be_successful

      api_merchant = JSON.parse(response.body)

      expect(api_merchant["data"]["id"]).to eq(merchant.id.to_s)
    end
  end
end
