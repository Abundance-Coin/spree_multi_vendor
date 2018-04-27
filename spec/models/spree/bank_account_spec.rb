describe Spree::BankAccount, vcr: true do
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

  describe 'save' do
    subject(:result) { bank_account.save }

    let(:bank_account) {
      described_class.new(opts)
    }
    let(:opts) { {} }

    context 'without tos_acceptance' do
      it { is_expected.to have_attributes(stripe_error: be_a(Stripe::InvalidRequestError)) }
      it { expect(result.stripe_error.message).to include('tos_acceptance[ip]') }
    end

    context 'with tos_acceptance' do
      let(:opts) { { request_ip: '233.232.42.11' } }

      it { expect(result.account_id).to be_truthy }
      it { expect(result.stripe_error).to be_nil }
    end

    context 'with all fields' do
      let(:opts) {
        {
          request_ip: '233.232.42.11',
          email: 'email@example.com',
          token: 'btok_1CLULSI93ruT9p2P7czGuVi2',
          dob: Time.current - 20.years,
          first_name: 'Sam',
          last_name: 'Peterson',
          ssn: '121112111',
          account_holder_type: 'company',
          city: 'San Francisco',
          line1: 'Folsom drv',
          postal_code: '91110',
          state: 'CA',
          document_file: File.open(File.absolute_path('./spec/fileset/legal.png'))
        } }

      it do
        expect(result.stripe_error).to be_nil
        expect(result.account_id).to be_truthy
      end
    end

    context 'when account is unverified' do
      let(:bank_account) { described_class.load('acct_1CKn3FBUFO0x0Mx5') }

      context 'when change address' do
        before { bank_account.city = 'San Diego' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change business name' do
        before { bank_account.business_name = 'Name' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change dob' do
        before { bank_account.dob = Time.current - 25.years }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change first name' do
        before { bank_account.first_name = 'Bob' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change ssn' do
        before { bank_account.ssn = '123456789' }

        it { expect(result.stripe_error).to be_nil }
      end
    end

    context 'when account is verified' do
      let(:bank_account) { described_class.load('acct_1CKmc2IFliRsdw3Y') }

      context 'when change address' do
        before { bank_account.city = 'San Diego' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change business name' do
        before { bank_account.business_name = 'Name' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change dob' do
        before { bank_account.dob = Time.current - 25.years }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change first name' do
        before { bank_account.first_name = 'Bob' }

        it { expect(result.stripe_error).to be_nil }
      end

      context 'when change ssn' do
        before { bank_account.ssn = '123456789' }

        it { expect(result.stripe_error).to be_nil }
      end
    end
  end

  describe 'load from stripe' do
    subject { described_class.load(account_id) }

    context 'when account id is wrong' do
      let(:account_id) { 'unknown' }

      it { is_expected.to have_attributes(account_id: account_id, business_name: nil) }
    end

    context 'when account id is correct' do
      let(:account_id) { 'acct_1CKmc2IFliRsdw3Y' }

      it do
        is_expected.to have_attributes(
          account_id: account_id,
          first_name: be_truthy,
          last_name: be_truthy,
          dob: be_truthy,
          token: be_truthy
        )
      end
    end
  end
end
