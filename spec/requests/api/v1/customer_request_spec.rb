require 'rails_helper'

describe 'Customers API' do
  describe 'record endpoints' do
    before(:each) do
      #
    end

    it "sends a list of customers" do
      create_list(:customer, 4)

      get '/api/v1/customers'

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers["data"].count).to eq(4)
    end

    it "can get one customer by its id" do
      id = create(:customer).id

      get "/api/v1/customers/#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["data"]["id"]).to eq(id.to_s)
    end

    it "can find a customer by its attributes" do
      customer = create(:customer, first_name: 'Ryan', last_name: 'Hantak')

      get '/api/v1/customers/find?last_name=HaNTak'

      expect(response).to be_successful

      api_customer = JSON.parse(response.body)

      expect(customer.id.to_s).to eq(api_customer["data"]["id"])
    end

    it "can find all customers matching an attribute" do
      customer_1 = create(:customer, first_name: 'Ryan', last_name: 'Hantak')
      customer_2 = create(:customer, first_name: 'Bob', last_name: 'Hantak')
      customer_3 = create(:customer, first_name: 'Bob', last_name: 'G')

      get '/api/v1/customers/find_all?last_name=HaNTaK'

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers["data"].count).to eq(2)
      expect(customers["data"][0]["id"]).to eq(customer_1.id.to_s)
      expect(customers["data"][1]["id"]).to eq(customer_2.id.to_s)
    end

    it "can send a random customer" do
      create_list(:customer, 5)

      get '/api/v1/customers/random'

      expect(response).to be_successful

      expect(response.body).to_not eq("")
    end
  end

  describe 'relationship endpoints' do
    before(:each) do
      @customer_1 = create(:customer, first_name: 'Ryan', last_name: 'Hantak')
      @customer_2 = create(:customer, first_name: 'Bob', last_name: 'Hantak')
      create_list(:invoice, 2, customer_id: @customer_1.id)
      create_list(:invoice, 2, customer_id: @customer_2.id)
    end

    it "can find all invoices associated with a customer" do
      get "/api/v1/customers/#{@customer_1.id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices["data"].count).to eq(2)
    end

    it "can find all transactions associated with a customer" do
      create(:transaction, invoice_id: @customer_1.invoices.first.id)
      create(:transaction, invoice_id: @customer_1.invoices.last.id)
      create(:transaction, invoice_id: @customer_2.invoices.first.id)
      create(:transaction, invoice_id: @customer_2.invoices.last.id)

      get "/api/v1/customers/#{@customer_1.id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions["data"].count).to eq(2)
    end
  end
end
