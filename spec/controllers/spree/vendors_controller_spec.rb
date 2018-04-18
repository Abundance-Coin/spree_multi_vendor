RSpec.describe Spree::VendorsController, type: :controller do
  describe '#show' do
    let(:vendor) { create(:vendor) }

    before { spree_get :show, id: vendor.id }

    it 'loads vendor' do
      expect(assigns(:vendor)).to eq vendor
    end

    describe 'loads products' do
      let!(:first_variant) { create(:variant, vendor: vendor) }

      it 'correctly' do
        expect(assigns(:products)).to eq vendor.products
      end

      context 'with more than one variant per product' do
        before { create(:variant, product: first_variant.product, vendor: vendor) }

        it 'correctly' do
          expect(assigns(:products).count).to eq 1
        end
      end
    end

    it 'paginates products' do
      expect(assigns(:products)).to respond_to(:total_pages)
    end
  end
end
