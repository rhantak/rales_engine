require 'rails_helper'

describe 'Transactions API' do
  describe 'record endpoints' do
    before(:each) do
      @merchant = create(:merchant)
      @customer = create(:customer)
      @invoice = create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)
    end

    it "sends a list of transactions" do
      create_list(:transaction, 3, invoice_id: @invoice.id)

      get '/api/v1/transactions'

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions["data"].count).to eq(3)
    end

    it "can get one transaction by its id" do
      id = create(:transaction, invoice_id: @invoice.id).id

      get "/api/v1/transactions/#{id}"

      transaction = JSON.parse(response.body)

      expect(response).to be_successful
      expect(transaction["data"]["id"]).to eq(id.to_s)
    end

    it "can find a transaction by its attributes" do
      transaction_1 = create(:transaction, result: 'failure', invoice_id: @invoice.id)
      transaction_2 = create(:transaction, result: 'success', invoice_id: @invoice.id)

      get '/api/v1/transactions/find?result=success'

      expect(response).to be_successful

      api_transaction = JSON.parse(response.body)

      expect(transaction_2.id.to_s).to eq(api_transaction["data"]["id"])
    end

    it "can find all items matching an attribute" do
      transaction_1 = create(:transaction, result: 'failure', invoice_id: @invoice.id)
      transaction_2 = create(:transaction, result: 'success', invoice_id: @invoice.id)
      transaction_3 = create(:transaction, result: 'success', invoice_id: @invoice.id)

      get '/api/v1/transactions/find_all?result=success'

      expect(response).to be_successful

      transactions = JSON.parse(response.body)
      expect(transactions["data"].count).to eq(2)
      expect(transactions["data"][0]["id"]).to eq(transaction_2.id.to_s)
      expect(transactions["data"][1]["id"]).to eq(transaction_3.id.to_s)
    end

    it "can send a random transaction" do
      create_list(:transaction, 3, invoice_id: @invoice.id)

      get '/api/v1/transactions/random'

      expect(response).to be_successful

      expect(response.body).to_not eq("")
    end
  end

  describe 'relationship endpoints' do
    it "can send the invoice associated with a transaction" do
      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)
      transaction = create(:transaction, invoice_id: invoice.id)

      get "/api/v1/transactions/#{transaction.id}/invoice"

      expect(response).to be_successful

      api_invoice = JSON.parse(response.body)

      expect(api_invoice["data"]["id"]).to eq(invoice.id.to_s)
    end
  end
end
