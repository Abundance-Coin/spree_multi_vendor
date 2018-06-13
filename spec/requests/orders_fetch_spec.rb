require 'spec_helper'

RSpec.describe 'Orders fetch', type: :request do
  subject(:fetch) do
    get '/api/v1/orders/fetch', params: { token: token, from_timestamp: from.to_i }
    response
  end

  let(:json) { JSON.parse(fetch.body, symbolize_names: true) }
  let(:token) { '' }
  let(:from) { Time.current - 1.day }

  context 'when vendor is authorized' do
    let(:vendor) { create(:vendor) }
    let(:user) { create(:user, spree_api_key: 'secure', vendors: [vendor]) }
    let(:token) { user.spree_api_key }

    before do
      create(:vendor_order_ready_to_ship, vendor: create(:vendor)) # order related to other vendor
    end

    context 'when no content' do
      it { is_expected.to have_http_status(:ok) }
      it { expect(json[:count]).to eq(0) }
    end

    context 'when have orders' do
      let!(:order) { create(:vendor_order_ready_to_ship, vendor: vendor) }

      it { expect(json[:count]).to eq(1) }
      it { expect(json).to include(orders: [hash_including(order_identifier: order.number)]) }
    end
  end
end
