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
end
