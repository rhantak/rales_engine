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

  xit 'can return a collection of items associated with a merchant' do

  end

  xit 'can return a collection of invoices associated with the merchant' do

  end

  xit "can return the top x merchants by revenue" do

  end

  xit "can return the total revenue for a date across all merchants" do

  end

  xit "can return the customer with the most successful transactions with a merchant" do

  end
end
