RSpec.describe 'Admin Vendor Bank', js: true, vcr: true do
  let(:vendor) { create(:vendor, gateway_account_profile_id: account_id) }
  let(:user) { create(:user, vendors: [vendor]) }

  before do
    Spree::Gateway::StripeGateway.create!(
      name: 'Credit Card',
      description: 'Pay by Stripe',
      active: true,
      display_on: 'both',
      preferences: {
        secret_key: '',
        publishable_key: '',
        test_mode: true
      }
    )
  end

  describe '#edit' do
    before do
      login_as(user, scope: :spree_user)
      visit spree.admin_vendor_bank_path
    end

    context 'when account is absent' do
      let(:account_id) { nil }

      it 'show empty form' do
        expect(find_field(id: 'bank_account_first_name').value).to be_empty
        expect(find_field(id: 'bank_account_business_name').value).to be_empty
        expect(find_field(id: 'bank_account_account_number').value).to be_empty
      end

      it 'create a new account' do
        fill_in(id: 'bank_account_first_name', with: 'First')
        fill_in(id: 'bank_account_last_name', with: 'Last')
        fill_in(id: 'bank_account_email', with: 'email@example.com')
        select('1970', from: 'bank_account_dob_1i')
        select('10', from: 'bank_account_dob_2i')
        select('11', from: 'bank_account_dob_3i')
        fill_in(id: 'bank_account_ssn', with: '123456789')
        attach_file('bank_account_document_file', File.absolute_path('./spec/fileset/legal.png'))
        fill_in(id: 'bank_account_business_name', with: '1234')
        fill_in(id: 'bank_account_city', with: 'Sacramento')
        fill_in(id: 'bank_account_line1', with: '1234')
        fill_in(id: 'bank_account_postal_code', with: '91110')
        fill_in(id: 'bank_account_state', with: 'CA')
        fill_in(id: 'bank_account_account_holder_name', with: 'Holder')
        fill_in(id: 'bank_account_routing_number', with: '111000025')
        fill_in(id: 'bank_account_account_number', with: '000123456789')
        fill_in(id: 'bank_account_tax_id', with: '123456789')
        find('#bank_account_token', visible: false).set('btok_1CLU1VI93ruT9p2PHsChNieK')

        click_button 'Update account'

        expect(vendor.reload.gateway_account_profile_id).to be_truthy
        expect(find_field(id: 'bank_account_account_number', disabled: true).value).to include('****')
      end
    end

    context 'when account is unverified' do
      let(:account_id) { 'acct_1CKn3FBUFO0x0Mx5' }

      it 'show filled form' do
        expect(find_field(id: 'bank_account_first_name').value).not_to be_empty
        expect(find_field(id: 'bank_account_business_name').value).not_to be_empty
        expect(find_field(id: 'bank_account_dob_1i').value).not_to be_empty
        expect(find_field(id: 'bank_account_dob_2i').value).not_to be_empty

        expect(find_field(id: 'bank_account_account_number', disabled: true).value).to include('****')
        expect(find_field(id: 'bank_account_routing_number', disabled: true).value).to be_present
        expect(find_field(id: 'bank_account_account_holder_name', disabled: true).value).to be_present
        expect(find_field(id: 'bank_account_account_holder_type', disabled: true).value).to be_present

        expect(find_link(id: 'change_account')).to be_truthy

        click_link(id: 'change_account')
        expect(find_field(id: 'bank_account_account_number').value).to be_empty
      end
    end

    context 'when account is verified' do
      let(:account_id) { 'acct_1CKmc2IFliRsdw3Y' }

      it 'update email' do
        fill_in(id: 'bank_account_city', with: 'Sacramento')
        click_button 'Update account'

        expect(Spree::Vendor.find(vendor.id).bank_account.city).to eq('Sacramento')
      end

      it 'update bank account' do
        old_account_id = vendor.bank_account.stripe_account_id
        find('#bank_account_token', visible: false).set('btok_1CLU79I93ruT9p2PsMvn3omj')
        click_button 'Update account'

        expect(Spree::Vendor.find(vendor.id).bank_account.stripe_account_id).not_to eq(old_account_id)
      end
    end
  end
end
