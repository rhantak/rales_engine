require 'rails_helper'
  describe 'Invoice items API' do
    describe 'record endpoints' do
      before(:each) do
        @customer = create(:customer)
        @merchant = create(:merchant)
        @invoice_1 =  create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)
        @invoice_2 =  create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)
        @item_1 = create(:item, merchant_id: @merchant.id)
        @item_2 = create(:item, merchant_id: @merchant.id)
        @ii_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id)
        @ii_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id)
        @ii_3 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id)
        @ii_4 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id)
      end

      it "sends a list of invoice items" do
        get '/api/v1/invoice_items'

        expect(response).to be_successful

        invoice_items = JSON.parse(response.body)

        expect(invoice_items["data"].count).to eq(4)
      end

      it "can find an invoice item by its id" do
        get "/api/v1/invoice_items/#{@ii_1.id}"

        expect(response).to be_successful

        invoice_item = JSON.parse(response.body)

        expect(invoice_item["data"]["id"]).to eq(@ii_1.id.to_s)
      end

      it "can get one invoice item by its attributes" do
        get "/api/v1/invoice_items/find?invoice_id=#{@invoice_1.id}"

        expect(response).to be_successful

        invoice_item = JSON.parse(response.body)

        expect(invoice_item["data"]["id"]).to eq(@ii_2.id.to_s || @ii_1.id.to_s)
      end

      it "can find all invoice items matching an attribute" do
        get "/api/v1/invoice_items/find_all?item_id=#{@item_2.id}"

        expect(response).to be_successful

        invoice_items = JSON.parse(response.body)

        expect(invoice_items["data"].count).to eq(2)
        expect(invoice_items["data"][0]["id"]).to eq(@ii_2.id.to_s)
        expect(invoice_items["data"][1]["id"]).to eq(@ii_4.id.to_s)
      end

      it "can send a random invoice item" do
        get '/api/v1/invoice_items/random'

        expect(response).to be_successful

        expect(response.body).to_not eq("")
      end
    end

    describe 'relationship endpoints' do
      before(:each) do
        @customer = create(:customer)
        @merchant = create(:merchant)
        @invoice_1 =  create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)
        @invoice_2 =  create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)
        @item_1 = create(:item, merchant_id: @merchant.id)
        @item_2 = create(:item, merchant_id: @merchant.id)
        @ii_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id)
        @ii_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id)
        @ii_3 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id)
        @ii_4 = create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_2.id)
      end

      it "can send the invoice which an invoice item belongs to" do
        get "/api/v1/invoice_items/#{@ii_3.id}/invoice"

        expect(response).to be_successful

        invoice = JSON.parse(response.body)

        expect(invoice["data"]["id"]).to eq(@invoice_2.id.to_s)
      end

      it "can send the item which an invoice item belongs to" do
        get "/api/v1/invoice_items/#{@ii_3.id}/item"

        expect(response).to be_successful

        item = JSON.parse(response.body)

        expect(item["data"]["id"]).to eq(@item_1.id.to_s)
      end
    end
  end
