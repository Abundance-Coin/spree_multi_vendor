describe Spree::StockLocation, type: :model do
  subject(:create_vendor) { create(:vendor) }

  let(:vendor) { create(:vendor) }
  let!(:variant) { create(:variant, vendor: vendor) }

  describe 'after create' do
    it "doesn't propagate to stock items for other vendors Stock Locations" do
      expect { create_vendor }.not_to change {
        variant.stock_locations.count
      }
    end
  end
end
