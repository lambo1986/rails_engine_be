require "rails_helper"

describe "merchants API" do
  it "fetches all merchants" do
    merchant = create(:merchant)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'fetches one merchant' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)


    data = merchant[:data]
    expect(data).to have_key(:id)
    expect(data[:id]).to be_an(String)

    expect(data[:attributes]).to have_key(:name)
    expect(data[:attributes][:name]).to be_a(String)
  end

  it 'throws error if id does not exist' do
    get "/api/v1/merchants/1"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=1")
  end
end
