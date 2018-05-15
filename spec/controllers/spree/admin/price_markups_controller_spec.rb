RSpec.describe Spree::Admin::PriceMarkupsController, type: :controller do
  let(:vendor) { create(:vendor) }
  let(:user) { create(:user, vendors: [vendor]) }
  let(:admin) { create(:admin_user) }
  let(:price_markup) { create(:price_markup, vendor: vendor) }

  describe '#edit' do
    subject { spree_get :edit, id: price_markup.id, vendor_id: vendor.id }

    context 'when has no permissions' do
      before { sign_in(user) }

      it { is_expected.not_to be_success }
    end

    context 'when has permissions' do
      before { sign_in(admin) }

      it { is_expected.to be_success }
    end
  end
end
