describe Spree::Variant do
  subject(:create_variant) { create(:variant, price: nil, cost_price: 1, vendor: vendor) }

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

    describe 'adjust price' do
      let(:variant) { create_variant }

      before { create(:price_markup, amount: 10, vendor: vendor) }

      it 'sets price with vendor markups' do
        expect(variant.price).to eq(variant.cost_price + vendor.price_markups.sum(:amount))
      end

      context 'when vendor is blank' do
        let(:vendor) { nil }

        it 'sets price according to cost_price' do
          expect(variant.price).to eq(variant.cost_price)
        end
      end
    end
  end

  describe 'after commit' do
    describe 'adjust price' do
      before do
        create(:price_markup, amount: 10, vendor: vendor)
      end

      let!(:variant) { create_variant }

      it 'sets price with vendor markups' do
        expect {
          variant.update(cost_price: 30)
        }.to change(variant, :price)
      end
    end
  end
end
