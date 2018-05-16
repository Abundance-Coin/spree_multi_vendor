describe Spree::RecalculateVendorVariantPrices, type: :worker do
  subject(:perform) { described_class.perform_async(vendor.id) }

  let(:vendor) { create(:vendor) }
  let!(:price_markup) { create(:price_markup, amount: 10, vendor: vendor) }
  let(:variant) { create(:variant, price: 1, cost_price: 1, vendor: vendor) }

  it { is_expected.not_to be_nil }

  it 'enqueues worker' do
    perform
    expect(described_class).to have_enqueued_sidekiq_job(vendor.id)
  end

  describe 'perform worker', run_jobs: true do
    before { perform }

    it { expect(variant.reload.price).to eq(price_markup.amount + variant.cost_price) }
  end
end
