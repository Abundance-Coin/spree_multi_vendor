RSpec.describe 'Admin Shipping Methods', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }

  context 'when user with admin role' do
    describe '#index' do
      it 'displays all shipping methods' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_shipping_methods_path
        # head + vendor shipping method
        expect(page).to have_selector('tr', count: 2)
      end
    end
  end

  context 'when user with vendor' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_shipping_methods_path
    end

    describe '#index' do
      it 'displays only vendor shipping method' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    describe '#create' do
      it 'can create a new shipping method' do
        click_link 'New Shipping Method'
        expect(page).to have_current_path spree.new_admin_shipping_method_path

        fill_in 'shipping_method_name', with: 'Vendor shipping method'
        check Spree::ShippingCategory.last.name

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(page).to have_current_path spree.edit_admin_shipping_method_path(Spree::ShippingMethod.last)
        expect(Spree::ShippingMethod.last.vendor_id).to eq vendor.id
      end
    end

    describe '#edit' do
      before do
        within_row(1) { click_icon :edit }
      end

      it 'can update an existing shipping method' do
        fill_in 'shipping_method_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      it 'shows validation error with blank name' do
        fill_in 'shipping_method_name', with: ''
        click_button 'Update'
        expect(page).not_to have_text 'successfully created!'
      end
    end
  end
end
