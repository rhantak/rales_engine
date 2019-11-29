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
end
