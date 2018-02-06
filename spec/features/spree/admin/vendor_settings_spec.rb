require 'spec_helper'

RSpec.describe 'Admin Vendor Settings', :js do
  let(:vendor) { create(:vendor) }
  let(:user) { create(:user, vendors: [vendor]) }

  describe '#edit' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_vendor_settings_path
    end

    it 'can update current vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      fill_in 'vendor_note', with: 'Vendor note'

      expect {
        expect {
          click_button 'Update'
        }.to change { vendor.reload.name }.to('Testing edit')
      }.to change { vendor.reload.note }.to('Vendor note')
    end

    it 'shows validation error with blank name' do
      fill_in 'vendor_name', with: ''
      click_button 'Update'
      expect(page).to have_text 'name can\'t be blank'
    end
  end
end
