RSpec.describe Spree::Admin::VendorInventoryController, type: :controller do
  let(:vendor) { create(:vendor) }
  let(:user) { create(:user, vendors: [vendor]) }
  let(:variant) { create(:variant, vendor: vendor) }

  describe '#index' do
    before { sign_in(user) }

    before { spree_get :index }

    it 'loads variants' do
      expect(assigns(:collection)).to include(variant)
    end

    it 'paginates variants' do
      expect(assigns(:collection)).to respond_to(:total_pages)
    end

    context 'when other vendor variants exist' do
      let(:other_variant) { create(:variant) }

      it 'does not load variant' do
        expect(assigns(:collection)).not_to include(other_variant)
      end
    end
  end
end
