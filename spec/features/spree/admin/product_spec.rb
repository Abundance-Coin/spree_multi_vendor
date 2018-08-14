RSpec.describe 'Admin Products', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:option_type) { create(:option_type, name: 'Testing option') }
  let!(:option_value) { create(:option_value, option_type: option_type) }
  let(:vendor_product) { create(:product, sku: 'Test2', option_types: [option_type]) }

  before do
    create(:variant, product: vendor_product, vendor: vendor)
    create(:product)
  end

  context 'when user with admin role' do
    before { login_as(admin, scope: :spree_user) }

    describe '#index' do
      it 'displays all products' do
        visit spree.admin_products_path
        expect(page).to have_selector('tr', count: 3)
      end
    end

    describe 'create variant' do
      it 'creates new variant with vendor id assigned' do
        visit spree.admin_product_variants_path(vendor_product)
        click_link 'New Variant'
        select 'S'
        click_button 'Create'
        expect(page).to have_text 'successfully created!'
        expect(Spree::Variant.last.vendor).to eq(vendor)
      end
    end
  end

  context 'when user with vendor' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_products_path
    end

    describe '#index' do
      it 'displays only vendor product' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    describe 'edit own product' do
      before do
        within_row(1) { click_icon :edit }
        expect(current_path).to eq spree.edit_admin_product_path(vendor_product)
      end

      it 'can update an existing product' do
        fill_in 'product_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      xit 'can update product master price' do
        fill_in 'product_price', with: 123
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        vendor_product.reload
        expect(vendor_product.price).to eq 123
      end

      it 'shows validation error with blank name' do
        fill_in 'product_name', with: ''
        click_button 'Update'
        expect(page).to have_text 'Name can\'t be blank'
      end
    end

    describe 'create variant' do
      it 'can create new variant' do
        visit spree.admin_product_variants_path(vendor_product)
        click_link 'New Variant'
        select 'S'
        click_button 'Create'
        expect(page).to have_text 'successfully created!'
        expect(Spree::Variant.last.option_values).to include option_value
      end
    end
  end
end
