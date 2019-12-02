require 'rails_helper'

describe 'Items API' do
  describe 'record endpoints' do
    before(:each) do
      @merchant = create(:merchant)
    end

    it "sends a list of items" do
      create_list(:item, 4, merchant_id: @merchant.id)

      get '/api/v1/items'
#
      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items["data"].count).to eq(4)
    end

    it "can get one item by its id" do
      id = create(:item, merchant_id: @merchant.id).id

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["data"]["id"]).to eq(id.to_s)
    end

    it "can find an item by its attributes" do
      item = create(:item, name: 'Chair', merchant_id: @merchant.id)

      get '/api/v1/items/find?name=CHaiR'

      expect(response).to be_successful

      api_item = JSON.parse(response.body)

      expect(item.id.to_s).to eq(api_item["data"]["id"])
    end

    it "can find all items matching an attribute" do
      item_1 = create(:item, name: 'Couch', merchant_id: @merchant.id)
      item_2 = create(:item, name: 'Couch', merchant_id: @merchant.id)

      get '/api/v1/items/find_all?name=CoUcH'

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items["data"].count).to eq(2)
      expect(items["data"][0]["id"]).to eq(item_1.id.to_s)
      expect(items["data"][1]["id"]).to eq(item_2.id.to_s)
    end

    it "can send a random item" do
      create_list(:item, 5, merchant_id: @merchant.id)

      get '/api/v1/items/random'

      expect(response).to be_successful

      expect(response.body).to_not eq("")
    end
  end

  describe 'relationship endpoints' do
    before(:each) do
      @merchant = create(:merchant)
      @item_1 = create(:item, merchant_id: @merchant.id)
    end

    it "can return the associated merchant" do
      get "/api/v1/items/#{@item_1.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)

      expect(merchant["data"]["id"]).to eq(@merchant.id.to_s)
    end

    it "can return a collection of associated invoice items" do
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id, merchant_id: @merchant.id)
      create_list(:invoice_item, 3, item_id: @item_1.id, invoice_id: invoice.id)

      get "/api/v1/items/#{@item_1.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].count).to eq(3)
    end
  end

  describe 'business intelligence endpoints' do
    before(:each) do
      @merchant = create(:merchant)
      @customer = create(:customer)
    end

    it "can list a variable number of top items ranked by total revenue generated" do
      item_1 = create(:item, merchant_id: @merchant.id)
      item_2 = create(:item, merchant_id: @merchant.id)
      item_3 = create(:item, merchant_id: @merchant.id)

      invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
      create(:invoice_item, quantity: 1, unit_price: 10.0, invoice_id: invoice.id, item_id: item_1.id)
      create(:invoice_item, quantity: 2, unit_price: 15.0, invoice_id: invoice.id, item_id: item_1.id)
      create(:invoice_item, quantity: 3, unit_price: 20.0, invoice_id: invoice.id, item_id: item_2.id)
      create(:invoice_item, quantity: 4, unit_price: 25.0, invoice_id: invoice.id, item_id: item_2.id)
      create(:invoice_item, quantity: 5, unit_price: 30.0, invoice_id: invoice.id, item_id: item_3.id)
      create(:invoice_item, quantity: 6, unit_price: 35.0, invoice_id: invoice.id, item_id: item_3.id)

      create(:transaction, result: 'success', invoice_id: invoice.id)

      limit = 2

      get "/api/v1/items/most_revenue?quantity=#{limit}"

      expect(response).to be_successful

      top_items = JSON.parse(response.body)

      expect(top_items["data"].count).to eq(2)
      expect(top_items["data"][0]["id"]).to eq(item_3.id.to_s)
      expect(top_items["data"][1]["id"]).to eq(item_2.id.to_s)
    end

    it "can return the date with the most sales for the given item" do
      item = create(:item, merchant_id: @merchant.id)

      invoice_1 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, created_at: "Sun, 25 Mar 2012 09:54:09 UTC +00:00")
      invoice_2 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, created_at: "Sun, 26 Mar 2012 09:54:09 UTC +00:00")
      invoice_3 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, created_at: "Sun, 27 Mar 2012 09:54:09 UTC +00:00")
      invoice_4 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, created_at: "Sun, 28 Mar 2012 09:54:09 UTC +00:00")

      create(:transaction, result: 'success', invoice_id: invoice_1.id)
      create(:transaction, result: 'success', invoice_id: invoice_2.id)
      create(:transaction, result: 'success', invoice_id: invoice_3.id)
      create(:transaction, result: 'success', invoice_id: invoice_4.id)

      create(:invoice_item, item_id: item.id, invoice_id: invoice_1.id, quantity: 10, unit_price: 10.00)
      create(:invoice_item, item_id: item.id, invoice_id: invoice_2.id, quantity: 20, unit_price: 10.00)
      create(:invoice_item, item_id: item.id, invoice_id: invoice_3.id, quantity: 30, unit_price: 10.00)
      create(:invoice_item, item_id: item.id, invoice_id: invoice_4.id, quantity: 5, unit_price: 10.00)

      get "/api/v1/items/#{item.id}/best_day"

      expect(response).to be_successful

      date = JSON.parse(response.body)

      expect(date["data"]["attributes"]["best_day"]).to eq(invoice_3.created_at.to_date.strftime("%Y-%m-%d"))
    end
  end
end
