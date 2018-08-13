describe Spree::Vendor do
  describe 'associations' do
    it { is_expected.to have_many(:shipping_methods) }
    it { is_expected.to have_many(:stock_locations) }
    it { is_expected.to have_many(:variants) }
    it { is_expected.to have_many(:vendor_users) }
    it { is_expected.to have_many(:users).through(:vendor_users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'initial state' do
    it 'initial state should be pending' do
      is_expected.to be_pending
    end
  end

  describe 'after_create' do
    let!(:vendor) { build(:vendor) }

    before { vendor.save! }

    it 'creates a stock location with default country' do
      expect(Spree::StockLocation.count).to eq(1)
      stock_location = Spree::StockLocation.last
      expect(vendor.stock_locations.first).to eq stock_location
      expect(stock_location.country).to eq Spree::Country.default
    end

    it 'has slug' do
      expect(vendor.slug).to be_truthy
    end
  end
end
