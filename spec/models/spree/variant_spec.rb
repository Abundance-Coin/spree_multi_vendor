describe Spree::Variant do
  subject(:create_variant) { create(:variant, vendor: vendor) }

  let(:vendor) { create(:vendor) }
  let(:other_vendor) { create(:vendor, name: 'Other vendor') }

  describe 'after create' do
    it "propagate to stock items only for Vendor's Stock Locations" do
      expect { create_variant }.to change {
        Spree::StockItem.where(stock_location: vendor.stock_locations.first).count
      }
    end

    it "doesn't propagate to stock items for other vendors Stock Locations" do
      expect { create_variant }.not_to change {
        Spree::StockItem.where(stock_location: other_vendor.stock_locations.first).count
      }
    end
  end
end
