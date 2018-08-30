RSpec.describe 'Vendors api', type: :request do
  let!(:admin) { create(:admin_user, spree_api_key: 'secure') }
  let!(:vendor) { create(:vendor, users: create_list(:user, 2)) }
  let(:token) { admin.spree_api_key }
  let(:json) { JSON.parse(response.body, symbolize_names: true) }

  describe '#index' do
    let(:params) { {} }

    before { get '/api/v1/vendors', params: params, headers: { 'X-Spree-Token': token } }

    it 'displays existing vendors' do
      expect(json.dig(:vendors, 0, :id)).to eq(vendor.id)
      expect(json.dig(:vendors, 0, :name)).to eq(vendor.name)
      expect(json.dig(:vendors, 0, :slug)).to eq(vendor.slug)
      expect(json.dig(:vendors, 0, :vendor_members)).to be_truthy
    end

    context 'when search' do
      let(:params) { { q: { name_cont: 'south' }} }

      it { expect(json.dig(:count)).to eq(0) }
    end
  end

  describe '#show' do
    before { get "/api/v1/vendors/#{vendor.id}", headers: { 'X-Spree-Token': token } }

    it { expect(json.dig(:id)).to eq(vendor.id) }
  end
end
